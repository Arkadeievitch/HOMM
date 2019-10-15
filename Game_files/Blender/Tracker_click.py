from bge import logic

def main(): 
    scene = logic.getCurrentScene()
    cont = logic.getCurrentController()
    
    mouse_Leftclick = cont.sensors["mouse_Leftclick"]
    
    if mouse_Leftclick.positive:
        Tracker_click = scene.objects["MouseClick_cursor"]
        Tracker_click.worldPosition = mouse_Leftclick.hitPosition