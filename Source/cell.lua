import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/animation'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local tilesImage = gfx.imagetable.new('img/tiles')
assert(tilesImage)

class('Cell').extends(playdate.graphics.sprite)

function Cell:init(position)
    Cell.super.init(self)

    self.position = position

    self:setCenter(0, 0)
    self:setImage(tilesImage[1])
    self:setZIndex(700)
    self:moveTo(position[1] * CELL_SIZE, position[2] * CELL_SIZE)
    self:add()
end

function Cell:update(dt)
    Cell.super.update(self)
    -- self.animationManager.update(dt)
end

function Cell:render(ctx)
    ctx.save()
    ctx.translate(self.position.x * CELL_SIZE, self.position.y * CELL_SIZE)

    self.animationManager.render(ctx)

    ctx.restore()
end

-- Évènement : avant que le joueur n'entre dans la case
function Cell:onBeforePlayerIn(_player)
    -- À surcharger
end

-- Évènement : lorsque le joueur est entièrement dans la case
--
-- @return `this` si la case est inchangée ou `null` pour la supprimer
function Cell:onAfterPlayerIn(_player, _game)
    return this
end

-- Évènement : lorsque le joueur a quitté la case
function Cell:onAfterPlayerOut()
    -- À surcharger
end

-- Est-ce qu'on peut rentrer sur la case ?
function Cell:canEnter(_direction)
    return true
end

-- Est-ce qu'on peut sortir de la case ?
function Cell:canLeave(_direction)
    return true
end

function Cell:getPosition()
    return self.position
end

function Cell:getAnimationManager()
    return self.animationManager
end

-- Pièce
class('Coin').extends(Cell)

function Coin:init(position)
    Coin.super.init(self, position)

    self:setImage(tilesImage[11])
end

function Coin:onAfterPlayerIn(_player)
    self:remove()
end

-- Rocher
class('Stone').extends(Cell)

function Stone:init(position)
    Stone.super.init(self, position)

    self:setImage(tilesImage[1])
end

function Stone:canEnter()
    return false
end

-- Bouton
class('Button').extends(Cell)

function Button:init(position, value)
    Button.super.init(self, position)

    self:setImage(tilesImage[82])

    self.value = value or 1
end

function Button:onAfterPlayerOut()
    self.value -= 1

    self:setImage(tilesImage[81])
end

function Button:canEnter(_direction)
    return self.value ~= 0
end

-- Tapis roulant
class('Conveyor').extends(Cell)

function Conveyor:init(position, direction)
    Conveyor.super.init(self, position)

    if direction == 'up' then
        self:setImage(tilesImage[31])
    elseif direction == 'down' then
        self:setImage(tilesImage[51])
    elseif direction == 'right' then
        self:setImage(tilesImage[41])
    elseif direction == 'left' then
        self:setImage(tilesImage[61])
    end

    self.direction = direction
end

function Conveyor:onAfterPlayerIn(player, _game)
    player:move(self.direction)

    return self
end

-- Tourniquet
class('Turnstile').extends(Cell)

function Turnstile:init(position, angle)
    Conveyor.super.init(self, position)

    self.angle = angle

    self:updateImage()
end

function Turnstile:updateImage()
    if self.angle == 'up-left' then
        self:setImage(tilesImage[71])
    elseif self.angle == 'up-right' then
        self:setImage(tilesImage[72])
    elseif self.angle == 'down-right' then
        self:setImage(tilesImage[73])
    elseif self.angle == 'down-left'then
        self:setImage(tilesImage[74])
    elseif self.angle == 'horizontal' then
        self:setImage(tilesImage[75])
    elseif self.angle == 'vertical' then
        self:setImage(tilesImage[76])
    elseif self.angle == 'up' then
        self:setImage(tilesImage[77])
    elseif self.angle == 'right' then
        self:setImage(tilesImage[78])
    elseif self.angle == 'down' then
        self:setImage(tilesImage[79])
    elseif self.angle == 'left' then
        self:setImage(tilesImage[80])
    end
end

function Turnstile:onAfterPlayerOut()
    if self.angle == 'up-left' then
        self.angle = 'up-right'
    elseif self.angle == 'up-right' then
        self.angle = 'down-right'
    elseif self.angle == 'down-right' then
        self.angle = 'down-left'
    elseif self.angle == 'down-left'then
        self.angle = 'up-left'
    elseif self.angle == 'horizontal' then
        self.angle = 'vertical'
    elseif self.angle == 'vertical' then
        self.angle = 'horizontal'
    elseif self.angle == 'up' then
        self.angle = 'right'
    elseif self.angle == 'right' then
        self.angle = 'down'
    elseif self.angle == 'down' then
        self.angle = 'left'
    elseif self.angle == 'left' then
        self.angle = 'up'
    end

    self:updateImage()
end

function Turnstile:canEnter(direction)
    if self.angle == 'up-left' and (direction == 'up' or direction == 'left') then
        return true
    end

    if self.angle == 'up-right' and (direction == 'up' or direction == 'right') then
        return true
    end

    if self.angle == 'down-right' and (direction == 'down' or direction == 'right') then
        return true
    end

    if self.angle == 'down-left' and (direction == 'down' or direction == 'left') then
        return true
    end

    if self.angle == 'horizontal' and (direction == 'right' or direction == 'left') then
        return true
    end

    if self.angle == 'vertical' and (direction == 'up' or direction == 'down') then
        return true
    end

    if self.angle == 'up' and direction ~= 'down' then
        return true
    end

    if self.angle == 'right' and direction ~= 'left' then
        return true
    end

    if self.angle == 'down' and direction ~= 'up' then
        return true
    end

    if self.angle == 'left' and direction ~= 'right' then
        return true
    end

    return false
end

function Turnstile:canLeave(direction)
    if self.angle == 'up-left' and (direction == 'down' or direction == 'right') then
        return true
    end

    if self.angle == 'up-right' and (direction == 'down' or direction == 'left') then
        return true
    end

    if self.angle == 'down-right' and (direction == 'up' or direction == 'left') then
        return true
    end

    if self.angle == 'down-left' and (direction == 'up' or direction == 'right') then
        return true
    end

    if self.angle == 'horizontal' and (direction == 'right' or direction == 'left') then
        return true
    end

    if self.angle == 'vertical' and (direction == 'up' or direction == 'down') then
        return true
    end

    if self.angle == 'up' and direction ~= 'up' then
        return true
    end

    if self.angle == 'right' and direction ~= 'right' then
        return true
    end

    if self.angle == 'down' and direction ~= 'down' then
        return true
    end

    if self.angle == 'left' and direction ~= 'left' then
        return true
    end

    return false
end

local a = [[

// Balise de début de niveau
export class Start extends Cell {
  public constructor(position: Point) {
    super(position)
  }

  public render(_ctx: CanvasRenderingContext2D): void {
    // Pas de rendu
  }
}

// Balise de fin de niveau
export class End extends Cell {
  private active: boolean

  public constructor(position: Point) {
    super(position)

    this.active = false

    this.getAnimationManager().addAnimation('inactive', [ 20 ])

    this.getAnimationManager().addAnimation('active', [ 21, 22, 23, 24, 23, 22 ], {
      frameDuration: 0.1,
    })

    this.getAnimationManager().play('inactive')
  }

  public onAfterPlayerIn(player: Player, game: Game): this | null {
    if (this.isActive()) {
      player.setImmobility(true)
      player.getAnimationManager().play('turn')

      setTimeout(() => {
        game.nextLevel()
      }, 480)
    }

    return this
  }

  public activate(): void {
    this.active = true

    this.getAnimationManager().play('active')
  }

  public isActive(): boolean {
    return this.active
  }
}

// Pièce
export class Coin extends Cell {
  public constructor(position: Point) {
    super(position)

    this.getAnimationManager().addAnimation('idle', [ 10 ])

    this.getAnimationManager().play('idle')
  }

  public onAfterPlayerIn(_player: Player, _game: Game): this | null {
    return null
  }
}

// Glace
export class Ice extends Cell {
  public constructor(position: Point) {
    super(position)

    this.getAnimationManager().addAnimation('idle', [ 2 ])

    this.getAnimationManager().play('idle')
  }

  public onAfterPlayerIn(player: Player, _game: Game): this | null {
    player.move(player.getDirection(), 'idle')

    return this
  }
}

// Élévation de terrain / Motte de terre
export class Elevation extends Cell {
  public constructor(position: Point) {
    super(position)

    this.getAnimationManager().addAnimation('idle', [ 1 ])

    this.getAnimationManager().play('idle')
  }

  public onBeforePlayerIn(player: Player): void {
    player.getAnimationManager().play(`jump-${Direction.Down.toString()}`, true)
  }

  public onAfterPlayerIn(player: Player, _game: Game): this | null {
    player.move(player.getDirection(), null)

    return this
  }

  public canEnter(direction: Direction): boolean {
    if (direction === Direction.Down) {
      return false
    }

    return true
  }
}

]]
