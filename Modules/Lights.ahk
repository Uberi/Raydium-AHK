class Lights
{
    static 1 := new Raydium.Lights.Light(1)
    static 2 := new Raydium.Lights.Light(2)
    static 3 := new Raydium.Lights.Light(3)
    static 4 := new Raydium.Lights.Light(4)
    static 5 := new Raydium.Lights.Light(5)
    static 6 := new Raydium.Lights.Light(6)
    static 7 := new Raydium.Lights.Light(7)
    static 8 := new Raydium.Lights.Light(8)

    class Light
    {
        __New(Index)
        {
            If Index Not Between 1 And 8
                throw Exception("Invalid light index: " . Index . ".",-1)
            ObjInsert(this,"",Object())
            this.Index := Index
            this.State := 0
        }

        __Get(Key)
        {
            If (Key != "")
                Return, this[""][Key]
        }

        __Set(Key,Value)
        {
            If (Key = "State")
            {
                If Value
                    DllCall("Raydium.dll\raydium_light_on","UInt",this.Index - 1,"CDecl") ;turn on the light
                Else
                    DllCall("Raydium.dll\raydium_light_off","UInt",this.Index - 1,"CDecl") ;turn off the light
            }
            ObjInsert(this[""],Key,Value)
            Return
        }
    }
}