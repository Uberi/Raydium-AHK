#NoEnv

GameWindow := new Raydium("Test Game")
GameWindow.Projection.FieldOfView := 60
;GameWindow.Projection.Type := "Orthographic"

DllCall("Raydium.dll\raydium_joy_key_emul","CDecl")

GameWindow.Lights[1].State := 1
GameWindow.Lights[1].Position := [1.0,2.0,1.0]

VarSetCapacity(LightPosition,16), NumPut(1,LightPosition,0,"Float"), NumPut(1,LightPosition,4,"Float"), NumPut(1,LightPosition,8,"Float"), NumPut(0,LightPosition,12,"Float")
DllCall("Raydium.dll\raydium_light_move","UInt",0,"UPtr",&LightPosition,"CDecl") ;move the light

pLightIntensities := DllCall("GetProcAddress","UPtr",GameWindow.hModule,"AStr","raydium_light_color")
NumPut(1000000.0,pLightIntensities + 0,0,"Float")

pLightColors := DllCall("GetProcAddress","UPtr",GameWindow.hModule,"AStr","raydium_light_color")
NumPut(1.0,pLightColors + 0,0,"Float"), NumPut(0.0,pLightColors + 0,4,"Float"), NumPut(1.0,pLightColors + 0,8,"Float"), NumPut(1.0,pLightColors + 0,12,"Float") ;green light
DllCall("Raydium.dll\raydium_light_update_all","UInt",0,"CDecl")

DllCall("Raydium.dll\raydium_background_color_change","Float",1.0,"Float",1.0,"Float",1.0,"CDecl")
;DllCall("Raydium.dll\raydium_fog_disable","CDecl")

UFO := DllCall("Raydium.dll\raydium_object_load","AStr","ufo.tri","CDecl")
If (UFO = -1)
    ExitApp ;error loading file

pCallBack := RegisterCallback("Display","Fast")
DllCall("Raydium.dll\raydium_callback","UPtr",pCallBack,"CDecl")
Return

class Raydium
{
    __New(Title = "",Width = 800,Height = 600,WindowType = "Resizable")
    {
        this.hModule := DllCall("LoadLibrary","Str","Raydium.dll")
        DllCall("Raydium.dll\raydium_init_args_hack","Int",1,"Str","","CDecl")

        If (WindowType = "Resizable") ;resizable window
            RenderMode := 0 ;RAYDIUM_RENDERING_WINDOW
        Else If (WindowType = "FullScreen") ;fullscreen
            RenderMode := 1 ;RAYDIUM_RENDERING_FULLSCREEN
        Else If (WindowType = "Fixed") ;fixed size window
            RenderMode := 10 ;RAYDIUM_RENDERING_WINDOW_FIXED
        Else ;unknown window type
            throw Exception("Unknown window type: " . WindowType . ".",-1)

        DllCall("Raydium.dll\raydium_window_create","UInt",Width,"UInt",Height,"Char",RenderMode,"AStr",Title,"CDecl")

        DllCall("Raydium.dll\raydium_texture_filter_change","UInt",2,"CDecl") ;RAYDIUM_TEXTURE_FILTER_TRILINEAR: highest quality texture filter

        this.Projection := new Raydium.Projection(this.hModule)
        this.Lights := new Raydium.Lights
    }

    #Include Modules\Projection.ahk
    #Include Modules\Lights.ahk

    __Delete()
    {
        DllCall("FreeLibrary","UPtr",this.hModule)
    }
}

Display()
{
    global UFO
    DllCall("Raydium.dll\raydium_clear_frame","CDecl")
    DllCall("Raydium.dll\raydium_object_draw","UInt",UFO,"CDecl")
    DllCall("Raydium.dll\raydium_camera_look_at","Float",3.0,"Float",2.0,"Float",2.0,"Float",0.0,"Float",0.0,"Float",0.0,"CDecl")
    DllCall("Raydium.dll\raydium_rendering_finish","CDecl")
}

ShowObject(ShowObject,Padding = "")
{
 ListLines, Off
 If !IsObject(ShowObject)
 {
  ListLines, On
  Return, ShowObject
 }
 ObjectContents := ""
 For Key, Value In ShowObject
 {
  If IsObject(Value)
   Value := "`n" . ShowObject(Value,Padding . A_Tab)
  ObjectContents .= Padding . Key . ": " . Value . "`n"
 }
 ObjectContents := SubStr(ObjectContents,1,-1)
 If (Padding = "")
  ListLines, On
 Return, ObjectContents
}