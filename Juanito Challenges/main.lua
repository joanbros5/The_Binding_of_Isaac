local mod = RegisterMod("Juanito Challenges",1)
local game = Game()
local papafly_challenge = Isaac.GetChallengeIdByName("Papa Fly Supremacy")
local seraphim_challenge = Isaac.GetChallengeIdByName("Seraphim descent")
local freezer_challenge = Isaac.GetChallengeIdByName("Inside the freezer")

--FUNCIÓN QUE SE EJECUTA APROX CADA FRAME
function mod:frameupdate()

	--Papa fly challenge mechanic
	if (Isaac.GetChallenge() == papafly_challenge) then
		if (Isaac.CountEnemies() ~= 0) then
			if (Isaac.GetFrameCount() % 120 == 0) then
				local papafly = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.PAPA_FLY, 0, false, false)
				local e = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BROWN_NUGGET_POOTER, 1, papafly[1].Position, Vector(0,0), papafly[1])
			end
		else 
			--Blue pooters remover
			for i, entity in ipairs(Isaac.GetRoomEntities()) do
				if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.BROWN_NUGGET_POOTER then
					entity:Die();
				end
			end
		end 
	end
end

--FUNCIÓN QUE SE EJECUTA CADA CAMBIO DE PISO
function mod:nextlevel()

	--Quita la chance de angel en el challenge de Seraphim
	if (Isaac.GetChallenge() == seraphim_challenge) then
		level = game:GetLevel();
		level:InitializeDevilAngelRoom(false, true);
	end
end

--FUNCIÓN QUE SE EJECUTA CUANDO ALGÚN PLAYER SE HACE DAÑO
function mod:playertakedamage()
	--Inside the freezer take damage mechanic
	if (Isaac.GetChallenge() == freezer_challenge) then
		local random = math.random(1,10);
		if (random == 1) then
			for i, entity in ipairs(Isaac.GetRoomEntities()) do
				if (entity:IsVulnerableEnemy() and not entity:IsBoss()) then
					entity:AddEntityFlags(1<<50);
					entity.HitPoints = 0;
					entity:TakeDamage(1, 0, EntityRef(Isaac.GetPlayer(0)), 0);
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.frameupdate);
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.nextlevel);
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.playertakedamage, EntityType.ENTITY_PLAYER);