# Initial release
## Changes from previously public shaders
## _Global_
- Blue Noise function rework
- Blue Noise size control
- Custom inspectors for nearly all shaders
- New/changed shader logic from older public versions

## _Shader Specific Changes_
**Luminous Light Volumes**
- Custom shader GUI
- Added real time color gradient editing
- Added Depth Fade Blue Noise
- Added Quest Depth Fade
- Added Blue Noise size control
- Added cookie projection
- Added real time generated 3D Noise in addition to 3D Texture noise
- Added Sort Priority control
- Added Global Intensity
- Improved Edge Falloff when looking into beam
- Switched to double face rendering
- Removed all color banding
- White Edge Falloff reworked into Edge Color Falloff
- Switch shader to Additive Blend instead of Alpha Blend

**Reticle++**
- Custom shader GUI
- Added Tint Color, no longer needing a separate Mod2x material for tinting
- Added reticle contrast and saturation control
- Added Blue Noise size control
- Added non-additive texture support
- Fixed rings sometimes showing up with specific reticle textures

**Lit Particle Depth Fade**
- Custom shader GUI
- Added render face control
- Added Normal control
- Added Depth Fade Blue Noise
- Added Blue Noise size control
- Added Quest Depth Fade
- Removed Alpha Shadows variant

**HDR Additive**
- Rebuilt shader in Amplify
- Custom shader GUI
- Added non-additive texture support
- Added depth fade controls
- Added Quest Depth Fade

**LitORM**
- Added render face control

**Lit Epidermis**
- Custom shader GUI

**Blob Shadow**
- Custom shader GUI

**Decal Lit & Unlit**
- Custom shader GUI

**Miscellaneous Changes**
- Organized Atlas Shaders folder
- Optimized specific functions
