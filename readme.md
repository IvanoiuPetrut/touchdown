# Space lander

## Names

- Touchdown
- Steady thrust
- Contact

## Theme of the game is balance

- The game is about a space lander that needs to land on a planet

## Development Plan

### 1. Phase 1

- _Goal_: Create a barebones playable prototype where controlling the ship and landing feels right. This is the most crucial phase.

- _Tasks_
  1. Basic Objects: Create a simple shape/sprite for the lander and a flat surface for the ground.
  2. Physics Implementation:
     Implement consistent gravity pulling the lander down.
     Implement basic thrust (e.g., Spacebar applies upward force).
     Implement rotation controls (e.g., A/D apply torque).
     Implement inertia/momentum (ship continues moving/rotating after controls are released).
  3. Collision & Landing Logic:
     Detect collision between the lander and the ground.
     Define landing conditions (max vertical/horizontal speed for safe landing vs. crash).
  4. Iteration & Tuning (Critical):
     Playtest constantly. Adjust physics parameters (gravity strength, thrust power, rotational force, mass, drag/friction) until the ship feels responsive but challenging, weighty but controllable. Spend significant time here.

### 2. Phase 2

- _Goal_: Turn the prototype into a basic, repeatable game loop.

- _Tasks_

  1. Fuel System: Implement a limited fuel resource that depletes when thrusting. Add a way to lose if fuel runs out mid-air.
  2. HUD (Heads-Up Display): Create a simple UI to display essential info:
     Vertical Speed
     Horizontal Speed
     Altitude (distance from ground/landing zone)
     Fuel Remaining
  3. _Level Structure_: Define a start position for the lander and a clear landing zone target on the ground.
  4. _Win/Loss States_: Implement clear screens or messages for successful landing, crashing, and running out of fuel.
  5. _Game Flow_: Add the ability to start a level and restart after winning or losing.
  6. _Basic Audio_: Add placeholder sound effects for thrust, crash, and successful landing.

  _Outcome_: A minimal but complete game loop. You can start, try to land within fuel limits, see your critical stats, and get a clear win/loss result with the option to try again.

### 3. Phase 3

- _Goal_: Build the Minimum Viable Product with basic aesthetics, audio, and a small amount of content.

- _Tasks_

  1. _Art Implementation_: Add basic visual elements:
     A simple, recognizable ship model.
     A basic terrain texture.
     A simple landing zone marker.
  2. _Audio Polish_: Replace placeholder sounds with better quality effects. Add sounds for rotation, maybe alerts (low fuel), and subtle background ambience or music.
  3. _Level Variety_: Design and implement 2-3 distinct levels. They could vary by:
     Starting position/altitude.
     Landing zone size or terrain flatness.
     Maybe slight gravity difference (keep it simple).
  4. _Game Flow_: Add the ability to start a level and restart after winning or losing.
  5. _Visual Polish_:
     Improve thruster visuals (flame effect).
     Implement a satisfying explosion effect for crashes.
     Add visual feedback for landing (e.g., landing gear compressing slightly, dust effects)
  6. _Basic Menus_: Implement a simple Start Menu and potentially a Level Selection screen (if more than 1 level)

### 4. Phase 4

- _Goal_: Expand the game based on the MVP's success and feedback.

- _Tasks_ (Select based on priority):
  1. Develop more levels with increasing complexity (e.g., obstacles, moving platforms, tighter landing zones).
  2. Introduce different ships with unique handling characteristics (fuel capacity, thrust power, rotation speed).
  3. Add mission variety (e.g., rescue missions, timed challenges, fuel efficiency goals).
  4. Implement scoring and potentially leaderboards.
  5. Refine graphics, add more environmental details, animations, and effects.
  6. Add more audio tracks and sound effects.
  7. Create a tutorial level/sequence.
  8. Add settings options (volume control, maybe control adjustments).

## Ideas

- Normaly the boost is for reducing the vertical speed, but what if you 180 the ship and use the boost to get faster to the landing zone because you have limited fuel?
- Landing gear physics (simple suspension/damping)
- Collision Sounds: Soft "clunk" or "hiss" for safe landing (suspension compressing). A louder "bang" or metallic crunch for a hard landing. A satisfying "BOOM" for a crash.
- Alerts: Low fuel warning beeps, maybe altitude or speed warnings.
- Ambiance: Subtle engine hum, the quiet vacuum of space, maybe occasional radio static/chatter for flavour.
- Cat based, in the hud you can see the cat's face and the cat's name
- The ship is normal, but maybe though space you can see bigger ships delivering cat food
- Lighting & Effects: Simple lighting to make the ship pop from the background. Shadows can help ground the ship. Effects like engine glow, small particle effects, or subtle atmospheric haze (if applicable) add polish.
- Terrain Complexity: Introduce challenging landings in narrow caves, on slopes, or requiring specific approach vectors.
- Obstacles: Static obstacles (rock spires, space debris) to navigate around. Dynamic obstacles (moving platforms, asteroids, laser grids?). Keep simple first.
- Environmental Factors: Different gravity levels per planet/zone. Maybe wind/atmospheric resistance on some planets (adds complexity). Limited visibility (fog/dust clouds?).
- Mission Types:
  - Standard Landing (within parameters).
  - Precision Landing (very small zone).
  - Resource Collection (land, pick something up, take off again?).
  - Timed runs.
  - Fuel efficiency challenges.
  - Sequence landings (land at point A, then B, then C).

## Inspiration

- https://www.reddit.com/r/PixelArt/comments/1lbi4q/oc_a_follow_up_to_the_rocket_heres_the_lander/#lightbox

- https://www.reddit.com/r/PixelArt/comments/1c7thfc/space_scene/#lightbox

- https://pigeonaut.itch.io/gb-lunar-lander

- https://danq.me/2018/03/03/lunar-lander/

## Colors

World 1
https://lospec.com/palette-list/cl8uds
#fcb08c
#ef9d7f
#d6938a
#b48d92
#a597a1
#8fa0bf
#9aabc9
#a5b7d4

World 2
https://lospec.com/palette-list/citrink
#ffffff
#fcf660
#b2d942
#52c33f
#166e7a
#254d70
#252446
#201533

World 3
https://lospec.com/palette-list/berry-nebula
#6ceded
#6cb9c9
#6d85a5
#6e5181
#6f1d5c
#4f1446
#2e0a30
#0d001a
