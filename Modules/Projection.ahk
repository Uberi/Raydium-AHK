class Projection
{
    __New(hModule)
    {
        ObjInsert(this,"",Object())
        this.ClipNear := 0.1
        this.ClipFar := 1000
        this.FieldOfView := 90

        this.pType := DllCall("GetProcAddress","UPtr",hModule,"AStr","raydium_projection")
    }

    __Get(Key)
    {
        If (Key != "")
            Return, this[""][Key]
    }

    __Set(Key,Value)
    {
        If (Key = "Type")
        {
            If (Value = "Orthographic")
            {
                NumPut(0,this.pType,0,"Char") ;RAYDIUM_PROJECTION_ORTHO
                DllCall("Raydium.dll\raydium_window_view_update","CDecl")
            }
            Else If (Value = "Perspective")
            {
                NumPut(1,this.pType,0,"Char") ;RAYDIUM_PROJECTION_PERSPECTIVE
                DllCall("Raydium.dll\raydium_window_view_update","CDecl")
            }
            Else
                throw Exception("Unknown projection: " . Value . ".",-1)
        }
        Else If (Key = "ClipNear")
        {
            If Value Is Not Number
                throw Exception("Invalid near clipping limit: " . Value . ".",-1)
            DllCall("Raydium.dll\raydium_window_view_perspective","Float",this.FieldOfView,"Float",Value,"Float",this.ClipFar,"CDecl") ;update the near clipping limit
        }
        Else If (Key = "ClipFar")
        {
            If Value Is Not Number
                throw Exception("Invalid far clipping limit: " . Value . ".",-1)
            DllCall("Raydium.dll\raydium_window_view_perspective","Float",this.FieldOfView,"Float",this.ClipNear,"Float",Value,"CDecl") ;update the near clipping limit
        }
        Else If (Key = "FieldOfView")
        {
            If Value Is Not Number
                throw Exception("Invalid field of view: " . Value . ".",-1)
            DllCall("Raydium.dll\raydium_window_view_perspective","Float",Value,"Float",this.ClipNear,"Float",this.ClipFar,"CDecl") ;update the near clipping limit
        }
        ObjInsert(this[""],Key,Value)
        Return
    }
}