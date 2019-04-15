
import GameLogic 
import Rasterizer 

#init stuff, show mouse
if not hasattr(GameLogic,'init'):
    GameLogic.init = 1
    Rasterizer.showMouse(1)

# load controller, set sensors
py = GameLogic.getCurrentController()
always,move,click = py.sensors

# load target "Cube"
obj = GameLogic.getCurrentScene().getObjectList()["Rouge"]
    
# find mouse    
if move.positive:
    pos = move.getHitPosition()
    
    # set "Cube" at mouse position on click
    if click.positive:
        obj.setPosition(pos)