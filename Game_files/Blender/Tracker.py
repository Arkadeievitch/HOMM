from bge import logic

def main(): 
    scene = logic.getCurrentScene()
    cont = logic.getCurrentController()
    
    mouse_over = cont.sensors["mouse_over"]
    
    if mouse_over.positive:
        tracker = scene.objects["MouseCursor"]
        tracker.worldPosition = mouse_over.hitPosition