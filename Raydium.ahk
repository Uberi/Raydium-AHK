#NoEnv

hModule := DllCall("LoadLibrary","Str","Raydium.dll")
DllCall("Raydium.dll\raydium_init_args_hack","Int",1,"Str","","CDecl")
Title := "Test"

DllCall("Raydium.dll\raydium_window_create","UInt",800,"UInt",600,"Char",10,"AStr",Title,"CDecl")
DllCall("Raydium.dll\raydium_texture_filter_change","UInt",2,"CDecl")

DllCall("Raydium.dll\raydium_window_view_perspective","Float",60,"Float",0.1,"Float",1000,"CDecl") ;change the field of view and visibility range

DllCall("Raydium.dll\raydium_light_on","UInt",0,"CDecl") ;turn on the first light
VarSetCapacity(LightPosition,16), NumPut(1,LightPosition,0,"Float"), NumPut(1,LightPosition,4,"Float"), NumPut(1,LightPosition,8,"Float"), NumPut(0,LightPosition,12,"Float")
DllCall("Raydium.dll\raydium_light_move","UInt",0,"UPtr",&LightPosition,"CDecl") ;move the light

pLightIntensities := DllCall("GetProcAddress","UPtr",hModule,"AStr","raydium_light_color")
NumPut(1000000.0,pLightIntensities + 0,0,"Float")

pLightColors := DllCall("GetProcAddress","UPtr",hModule,"AStr","raydium_light_color")
NumPut(1.0,pLightColors + 0,0,"Float"), NumPut(0.0,pLightColors + 0,4,"Float"), NumPut(1.0,pLightColors + 0,8,"Float"), NumPut(1.0,pLightColors + 0,12,"Float") ;green light
DllCall("Raydium.dll\raydium_light_update_all","UInt",0)

DllCall("Raydium.dll\raydium_background_color_change","Float",1.0,"Float",1.0,"Float",1.0,"CDecl")

UFO := DllCall("Raydium.dll\raydium_object_load","AStr","ufo.tri","CDecl")
If (UFO = -1)
    ExitApp ;error loading file

pCallBack := RegisterCallback("Display","Fast")
DllCall("Raydium.dll\raydium_callback","UPtr",pCallBack,"CDecl")
Return

Display()
{
    global UFO
    DllCall("Raydium.dll\raydium_clear_frame","CDecl")
    DllCall("Raydium.dll\raydium_object_draw","UInt",UFO,"CDecl")
    DllCall("Raydium.dll\raydium_camera_look_at","Float",3.0,"Float",2.0,"Float",2.0,"Float",0.0,"Float",0.0,"Float",0.0,"CDecl")
    DllCall("Raydium.dll\raydium_rendering_finish","CDecl")
}