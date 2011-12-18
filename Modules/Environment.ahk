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
            DllCall("Raydium.dll\raydium_background_color_change","Float",Value[1],"Float",Value[2],"Float",Value[3],"CDecl")
        }
        ObjInsert(this[""],Key,Value)
        Return, this
    }
}