class Environment
{
    __New()
    {
        ObjInsert(this,"",Object())
    }

    __Get(Key)
    {
        If (Key != "")
            Return, this[""][Key]
    }

    __Set(Key,Value)
    {
        If (Key = "Background")
        {
            If !IsObject(Value)
                throw Exception("Invalid color: " . Position . ".",-1)
            DllCall("Raydium.dll\raydium_background_color_change","Float",Value[1],"Float",Value[2],"Float",Value[3],"Float",ObjHasKey(Value,4) ? Value[4] : 1.0,"CDecl")
        }
        Else If (Key = "Ambient")
        {
            If !IsObject(Value)
                throw Exception("Invalid color: " . Position . ".",-1)
            VarSetCapacity(GlobalAmbience,16)
            NumPut(Value[1],GlobalAmbience,0,"Float")
            NumPut(Value[2],GlobalAmbience,4,"Float")
            NumPut(Value[3],GlobalAmbience,8,"Float")
            NumPut(ObjHasKey(Value,4) ? Value[4] : 1.0,GlobalAmbience,12,"Float")
            DllCall("opengl32.dll\glLightModelfv","UInt",0xB53,"UPtr",&GlobalAmbience) ;GL_LIGHT_MODEL_AMBIENT
        }
        ObjInsert(this[""],Key,Value)
        Return, this
    }
}