#NoEnv

GameWindow := new Raydium("Test Game")
GameWindow.Camera.FieldOfView := 60
;GameWindow.Camera.Type := "Orthographic"

GameWindow.Lights[1].State := 1
GameWindow.Lights[1].Position := [4.0,4.0,4.0]
GameWindow.Lights[1].Intensity := 1000000 ;wip: not working
GameWindow.Lights[1].Color := [0.0,1.0,0.0]

GameWindow.Environment.Fog.State := 1
GameWindow.Environment.Fog.Type := "Exponential"
GameWindow.Environment.Fog.Density := 0.05

;CameraX := 10, CameraY := 10, CameraZ := 20

Ground := DllCall("Raydium.dll\raydium_object_load","AStr","test.tri","CDecl")
If (Ground = -1)
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
        Else ;invalid window type
            throw Exception("Invalid window type: " . WindowType . ".",-1)

        DllCall("Raydium.dll\raydium_window_create","UInt",Width,"UInt",Height,"Char",RenderMode,"AStr",Title,"CDecl")

        DllCall("Raydium.dll\raydium_texture_filter_change","UInt",2,"CDecl") ;RAYDIUM_TEXTURE_FILTER_TRILINEAR: highest quality texture filter

        this.Camera := new Raydium.Camera(this.hModule)
        this.Lights := new Raydium.Lights
        this.Environment := new Raydium.Environment
        Raydium.Lights.pColors := DllCall("GetProcAddress","UPtr",this.hModule,"AStr","raydium_light_color")
        Raydium.Lights.pIntensities := DllCall("GetProcAddress","UPtr",this.hModule,"AStr","raydium_light_intensity")
    }

    #Include Modules\Camera.ahk
    #Include Modules\Lights.ahk
    #Include Modules\Environment.ahk

    __Delete()
    {
        DllCall("FreeLibrary","UPtr",this.hModule)
    }
}

Display()
{
    global Ground, UFO
    global GameWindow, CameraX, CameraY, CameraZ ;wip: temporary

    ;DllCall("Raydium.dll\raydium_joy_key_emul","CDecl")
    ;CameraX += NumGet(DllCall("GetProcAddress","UPtr",GameWindow.hModule,"AStr","raydium_joy_x"),0,"Float")
    ;CameraY += NumGet(DllCall("GetProcAddress","UPtr",GameWindow.hModule,"AStr","raydium_joy_y"),0,"Float")
    ;DllCall("Raydium.dll\raydium_camera_look_at","Float",CameraX,"Float",CameraY,"Float",CameraZ,"Float",0.0,"Float",0.0,"Float",0.0,"CDecl")

    DllCall("Raydium.dll\raydium_camera_freemove","UInt",1,"CDecl")

    DllCall("Raydium.dll\raydium_clear_frame","CDecl")
    DllCall("Raydium.dll\raydium_object_draw","UInt",Ground,"CDecl")
    DllCall("Raydium.dll\raydium_rendering_finish","CDecl")
}