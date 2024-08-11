skirtPhysics = {}

--Skirt group structure:
--root
--	> Front
--		> FrontCenter
--		> FrontLeft
--		> FrontRight
-- > Back
--		> BackCenter
-- 	> BackLeft
-- 	> BackRight
-- > FrontLeftCorner
-- 	> FrontLeftCornerPivot
-- > FrontRightCorner
-- 	> FrontRightCornerPivot
-- > BackLeftCorner
-- 	> BackLeftCornerPivot
-- > BackRightCorner
-- 	> BackRightCornerPivot

-- see example model for how to rig properly

local min = math.min
local max = math.max

--example call:

--local skirtHandler = skirtPhysics.new(
--		nil,	--skirt root modelpath
--		nil,	--restAngle (25)
-- 	nil,	--angleAdd (5)
-- 	nil,	--legMultiplier (1)
-- 	nil		--crouchOffset (vec(0,0.5,-0.8))
--)

--values can be modifed or checked at runtime by indexing values in the handler table with a script

--eg.
--local skirtHandler = skirtPhysics.new()
--skirtHandler.restAngle = 20
--if skirtHandler.legMultiplier < 1 then return end


--adds skirt physics to the supplied skirt Modelpath
--root (modelPart): modelpath to the skirt's root, see above and example model for proper skirt rigging
--restAngle (number): the default and minimum angle for the skirt
--angleAdd (number): how many degrees offset from the leg's rotation the skirt should be at
--legMultiplier (number): multiplier  for the leg rotation. Use if you reduce actual leg rotation by a multiplier 
--crouchOffset (vec3): vector to add to the skirt's pos when crouching 
function skirtPhysics.new(root, restAngle, angleAdd, legMultiplier, crouchOffset)
	assert(root, "SkirtPhysics: The skirt root Modelpath is incorrect.")

	local handler = {}
	
	handler.root = root
	handler.restAngle = restAngle or 25
	handler.angleAdd = angleAdd or 5
	handler.legMultiplier = legMultiplier or 1
	handler.crouchOffset = crouchOffset or vec(0,0.5,-0.8)

	function events.render()
		local restAngle = handler.restAngle
		local angleAdd = handler.angleAdd
		local legMultiplier = handler.legMultiplier
		local cornerGain = 0.5
	
		local leftLegRot = vanilla_model.LEFT_LEG:getOriginRot().x*legMultiplier
		local rightLegRot = vanilla_model.RIGHT_LEG:getOriginRot().x*legMultiplier
	
		--front
		local frontLeft = max(restAngle, leftLegRot+angleAdd)
		local frontRight = max(restAngle, rightLegRot+angleAdd)
		
		handler.root.Front.FrontCenter:setRot(frontLeft == frontRight and frontLeft or max(restAngle, leftLegRot*0.66, rightLegRot*0.66),frontRight-frontLeft,0)
		handler.root.Front.FrontLeft:setRot(frontLeft,0,0)
		handler.root.Front.FrontRight:setRot(frontRight,0,0)
		
		--back
		local backLeft = min(-restAngle, leftLegRot-angleAdd)
		local backRight = min(-restAngle, rightLegRot-angleAdd)
		
		handler.root.Back.BackCenter:setRot(backLeft == backRight and backLeft or min(-restAngle, leftLegRot*0.66, rightLegRot*0.66),backRight-backLeft,0)
		handler.root.Back.BackLeft:setRot(backLeft,0,0)
		handler.root.Back.BackRight:setRot(backRight,0,0)
		
		--corners
		handler.root.FrontLeftCorner:setRot(restAngle,max(45,frontLeft),0)
		.FrontLeftCornerPivot:setRot(0,0,max(0,(frontLeft-restAngle)*cornerGain))
		
		handler.root.FrontRightCorner:setRot(restAngle,min(-45,-frontRight),0)
		.FrontRightCornerPivot:setRot(0,0,min(0,(-frontRight+restAngle)*cornerGain))
		
		handler.root.BackLeftCorner:setRot(-restAngle,min(-45,backLeft),0)
		.BackLeftCornerPivot:setRot(0,0,max(0,(-backLeft-restAngle)*cornerGain))
		
		handler.root.BackRightCorner:setRot(-restAngle,max(45,-backRight),0)
		.BackRightCornerPivot:setRot(0,0,min(0,(backRight+restAngle)*cornerGain))
		
		--crouch adjust
		if player:isLoaded() then
			handler.root:setPos(player:getPose() == "CROUCHING" and handler.crouchOffset or vec(0,0,0)):setRot(-vanilla_model.BODY:getOriginRot().x,0,0)
		end
	end
	
	return handler
end

return skirtPhysics