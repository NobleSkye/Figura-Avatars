-- any text after a -- is ignored by figura. they're called comments, and basically let
-- developers write text related to stuff. this file uses them to describe what you're changing.

-- user configuration
-- if you're just using this model, changing these values is all you'll want to do.

BoobScale = 0.8 -- boob scale. 1 is equivalent to the older versions.
DepthScaleFactor = 1.15 -- factor for pushing boobs out with scale. best to leave as is.

-- developer configuration - end users please ignore this !!
-- the following variables are used for setting our uv alignment with scaling. 
-- if you change proportions in blockbench you'll need to set these again.
-- https://www.desmos.com/calculator/dbrfctzktq will help with it.
UVFactorBody = -10.4964
UVOffsetBody = 10.4945
UVFactorJacket = -18.5676
UVOffsetJacket = 18.625
UVFactorChestplate = -21.756
UVOffsetChestplate = 22.0779