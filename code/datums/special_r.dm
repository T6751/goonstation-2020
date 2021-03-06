
datum/special_respawn
//	var/list/dead = list()
	var/mob/dead/observer/target

	proc/find_player(var/type = "an unknown")
		var/list/eligible = dead_player_list()

		if (!eligible.len)
			return 0
		target = pick(eligible)

		if(target)
			target.respawning = 1
//			boutput(target, text("You have been picked to come back into play as [type], enter your new body now."))
			return target
		else
			return 0


	proc/spawn_syndies(var/number = 3)
		var/r_number = 0
		var/B = pick(syndicatestart)

		if(!B)	return
		for(var/c = 0, c < number, c++)
			var/player = find_player("a syndicate agent")
			if(player)
				var/check = spawn_character_human("[syndicate_name()] Operative #[c+1]",player,B,"syndie")
				if(!check)
					break
				r_number ++
				SPAWN_DBG(5 SECONDS)
					if(player && !player:client)
						qdel(player)

		for (var/obj/landmark/A in landmarks)//world)
			LAGCHECK(LAG_LOW)
			if (A.name == "Syndicate-Gear-Closet")
				new /obj/storage/closet/syndicate/personal(A.loc)
				A.dispose()
				continue

			if (A.name == "Syndicate-Bomb")
				new /obj/item/ammo/bullets/a357(A.loc)
				A.dispose()
				continue

			if (A.name == "Nuclear-Closet")
				new /obj/storage/closet/syndicate/nuclear(A.loc)
				A.dispose()
				continue

			if (A.name == "Breaching-Charges")
				new /obj/item/breaching_charge/thermite(A.loc)
				new /obj/item/breaching_charge/thermite(A.loc)
				new /obj/item/breaching_charge/thermite(A.loc)
				new /obj/item/breaching_charge/thermite(A.loc)
				new /obj/item/breaching_charge/thermite(A.loc)
				A.dispose()
				continue


		message_admins("[r_number] syndicate agents spawned at Syndicate Station.")
		return

	proc/spawn_normal(var/number = 3)
		var/r_number = 0
		for(var/c = 0, c < number, c++)
			var/mob/player = find_player("a person")
			if(player)
				var/mob/living/carbon/human/normal/M = new/mob/living/carbon/human/normal(pick(latejoin))
				if(!player.mind)
					player.mind = new (player)
				player.mind.transfer_to(M)
				//M.ckey = player:ckey

				r_number ++
				SPAWN_DBG(5 SECONDS)
					if(player && !player:client)
						qdel(player)
			else
				break
		message_admins("[r_number] players spawned.")

	proc/spawn_as_job(var/number = 3, var/datum/job/job)
		var/r_number = 0
		for(var/c = 0, c < number, c++)
			var/mob/player = find_player("a person")
			if(player)
				var/mob/living/carbon/human/normal/M = new/mob/living/carbon/human/normal(pick(latejoin))
				SPAWN_DBG(0)
					M.JobEquipSpawned(job.name)

				if(!player.mind)
					player.mind = new (player)
				player.mind.transfer_to(M)

				r_number ++
				SPAWN_DBG(5 SECONDS)
					if(player && !player:client)
						qdel(player)
			else
				break
		message_admins("[r_number] players spawned.")

	proc/spawn_custom(var/blType, var/number = 3)
		var/r_number = 0
		for(var/c = 0, c < number, c++)
			var/mob/player = find_player("a person")
			if(player)
				var/mob/M = new blType(pick(latejoin))
				if(!player.mind)

					player.mind = new (player)
				player.mind.transfer_to(M)

				//M.ckey = player:ckey
				r_number++
				SPAWN_DBG(rand(1,10))
					M.set_clothing_icon_dirty()
				SPAWN_DBG(5 SECONDS)
					if(player && !player:client)
						qdel(player)
			else
				break
		message_admins("[r_number] players spawned.")

	proc/spawn_welder(var/number = 1)
		var/list/landlist = new/list()
		var/obj/landmark/B
		var/trashstation = "No"
		for (var/obj/landmark/A in landmarks)//world)
			if (A.name == "SR Welder")
				landlist.Add(A)
		B = pick(landlist)
		if(!B)	return
		var/player = input(usr,"Who?","Spawn Welder",) as mob in world
		if(station_creepified == 0)
			trashstation = alert("Make the station creepy and dark?","Spawn Welder","Yes","No")
		if(player)
			var/check = 0
			check = spawn_character_human("The Welder",player,B,"Welder")
			if(!check)
				return
			SPAWN_DBG(5 SECONDS)
				if(trashstation == "Yes")
					creepify_station()
					bust_lights()
					station_creepified = 1
				if(player && !player:client)
					del(player)

			message_admins("A Welder has spawned.", 1)

/*
	proc/spawn_commandos(var/number = 3)
		var/r_number = 0
		var/obj/landmark/B
		for (var/obj/landmark/A in landmarks)//world)
			if (A.name == "SR commando")
				B = A
		for(var/c = 0, c < number, c++)
			var/player = find_player("a commando")
			if(player)
				var/check = spawn_character_human("Central Command Officer #[c+1]",player,B,"commando")
				if(!check)
					break
				r_number ++
				SPAWN_DBG(5 SECONDS)
					if(player && !player:client)
						qdel(player)
		message_admins("[r_number] officers spawned.")
		return


	proc/spawn_aliens(var/number = 1,var/location = null)
		if(!location)
			return 0

		for(var/c = 0, c < number, c++)
			var/player = find_player("an alien")
			if(player)
				var/check = spawn_character_alien(player,location)
				if(!check)
					break
				SPAWN_DBG(5 SECONDS)
					if(player && !player:client)
						qdel(player)
				return 1
		return 0


	proc/spawn_turds(var/number = 5)
		boutput(src, "The TURDS ship is gone, so no.")
		return//No the ship is gone
		var/r_number = 0
		var/obj/landmark/B
		var/commander = 0
		for (var/obj/landmark/A in landmarks)//world)
			if (A.name == "SR Turds-Spawn")
				B = A

		if(!B)	return
		for(var/c = 0, c < number, c++)
			var/player = find_player("a T.U.R.D.S. Commando")
			if(player)
				var/check = 0
				if(!commander)
					check = spawn_character_human("T.U.R.D.S. Commander",player,B,"T.U.R.D.S.")
					commander = 1
				else
					check = spawn_character_human("T.U.R.D.S. Commando #[c+1]",player,B,"T.U.R.D.S.")
				if(!check)
					break
				r_number ++
				SPAWN_DBG(5 SECONDS)
					if(player && !player:client)
						qdel(player)

		message_admins("[r_number] T.U.R.D.S. Commandos spawned.")
		return

	proc/spawn_smilingman(var/number = 1)
		var/list/landlist = new/list()
		var/obj/landmark/B
		for (var/obj/landmark/A in landmarks)//world)
			if (A.name == "SR Welder")
				landlist.Add(A)
		B = pick(landlist)
		if(!B)	return
		var/player = input(usr,"Who?","Spawn Smiling Man",) as mob in world
		if(player)
			var/check = 0
			check = spawn_character_human("The Smiling Man",player,B,"Smiling Man")
			if(!check)
				return
			SPAWN_DBG(5 SECONDS)
				if(player && !player:client)
					qdel(player)

			message_admins("A Smiling Man has spawned.")
*/

	proc/spawn_character_human(var/rname = "Unknown", var/mob/player = null, var/obj/spawn_landmark = null,var/equip = "none")
		if(!player||!spawn_landmark)
			return 0
		var/mob/living/carbon/human/mob

		if(rname == "The Welder")
			mob = new /mob/living/carbon/human/welder(spawn_landmark.loc)
		if(rname == "The Smiling Man")
			mob = new /mob/living/carbon/human(spawn_landmark.loc)
			mob.equip_if_possible(new /obj/item/device/radio/headset(mob), mob.slot_ears)
			mob.equip_if_possible(new /obj/item/clothing/under/suit/pinstripe(mob), mob.slot_w_uniform)
			mob.equip_if_possible(new /obj/item/clothing/shoes/black(mob), mob.slot_shoes)
			var/obj/item/clothing/gloves/latex/gloves = new /obj/item/clothing/gloves/latex
			gloves.name = "Kidskin Gloves"
			mob.equip_if_possible(gloves, mob.slot_gloves)
			mob.equip_if_possible(new /obj/item/clothing/mask/smile(mob), mob.slot_wear_mask)
			mob.equip_if_possible(new /obj/item/dagger/smile(mob), mob.slot_r_hand)
			for (var/obj/item/O in mob.contents)
				O.cant_other_remove = 1
				O.cant_self_remove = 1
			mob.nodamage = 1
			mob.bioHolder.AddEffect("xray")
			mob.verbs += /client/proc/smnoclip
			mob.bioHolder.AddEffect("accent_smiling")
		else
			mob = new /mob/living/carbon/human/normal(spawn_landmark)
		mob.real_name = rname

		if(!player.mind)
			player.mind = new (player)
		player.mind.transfer_to(mob)

		/*
		mob.mind = new
		mob.mind.key = player.key
		mob.mind.current = player

		//mob.key = player.key
		^*/
		mob.mind.special_role = equip
		SPAWN_DBG(5 DECI SECONDS)
			if (mob)
				eq_mob(equip,mob)
				mob.set_clothing_icon_dirty()
		return 1


/*
	proc/spawn_character_alien(var/mob/player = null, var/spawn_landmark = null)
		if(!player)
			return 0

		var/mob/living/carbon/alien/larva/mob = new /mob/living/carbon/alien/larva(spawn_landmark)

		player.client.mob = mob

		mob.mind = new
		// drsingh attempted fix for Cannot read null.key
		if (player != null) mob.mind.key = player.key
		mob.mind.current = player
		mob.key = mob.mind.key
		mob.mind.special_role = "alien"

		return 1
*/
/*
Note:

Wouldn't client.mob not be easier for this?

EndNote

		mob.mind = new
		mob.mind.key = player.key
		mob.mind.current = player
		mob.key = player.key
		return 1
*/

	proc/eq_mob(var/type, var/mob/living/carbon/human/user)
		if(!type) return
		switch(type)

			if("syndie")
				equip_syndicate(user)
				return
			if("commando")
				user.equip_if_possible(new /obj/item/clothing/under/color/red(src), user.slot_w_uniform)
				user.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), user.slot_wear_suit)
				user.equip_if_possible(new /obj/item/clothing/head/helmet(src), user.slot_head)
				user.equip_if_possible(new /obj/item/clothing/shoes/brown(src), user.slot_shoes)
				user.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), user.slot_glasses)
				user.equip_if_possible(new /obj/item/handcuffs(src), user.slot_in_backpack)
				user.equip_if_possible(new /obj/item/handcuffs(src), user.slot_in_backpack)
				user.equip_if_possible(new /obj/item/baton(src), user.slot_belt)
				user.equip_if_possible(new /obj/item/device/flash(src), user.slot_l_store)
				user.equip_if_possible(new /obj/item/device/radio/headset/security(src), user.slot_ears)
				//var/obj/item/implant/sec/S = new /obj/item/implant/sec(user)
				//S.implanted = 1
				//S.implanted(user)
				//S.owner = user
				//user.implant.Add(S)

			if ("Welder")
				var/obj/item/device/radio/R = new /obj/item/device/radio/headset(user)
				user.equip_if_possible(R, user.slot_ears)
				user.equip_if_possible(new /obj/item/clothing/gloves/black(user), user.slot_gloves)
				var/obj/item/clothing/head/helmet/welding/W = new/obj/item/clothing/head/helmet/welding(user)
				W.cant_self_remove = 1
				W.cant_other_remove = 1
				user.equip_if_possible(W, user.slot_head)
				user.equip_if_possible(new /obj/item/clothing/shoes/black(user), user.slot_shoes)
				user.equip_if_possible(new /obj/item/clothing/suit/armor/vest(user), user.slot_wear_suit)
				user.equip_if_possible(new /obj/item/clothing/under/color(user), user.slot_w_uniform)
				user.mind.welder_knife = "[pick(rand(1, 999))]"
				var/obj/item/knife/K = new/obj/item/knife(user)
				K.tag = user.mind.welder_knife
				user.equip_if_possible(K, user.slot_r_hand)
				user.make_welder()

			if ("T.U.R.D.S.")
				var/obj/item/device/radio/R = new /obj/item/device/radio/headset/security(user)
				user.equip_if_possible(R, user.slot_ears)
				user.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(user), user.slot_glasses)
				user.equip_if_possible(new /obj/item/clothing/gloves/black(user), user.slot_gloves)
				user.equip_if_possible(new /obj/item/clothing/head/helmet/turd(user), user.slot_head)
				user.equip_if_possible(new /obj/item/clothing/shoes/swat(user), user.slot_shoes)
				user.equip_if_possible(new /obj/item/clothing/suit/armor/turd(user), user.slot_wear_suit)
				user.equip_if_possible(new /obj/item/clothing/under/misc/turds(user), user.slot_w_uniform)
				user.equip_if_possible(new /obj/item/storage/backpack(user), user.slot_back)
//				user.equip_if_possible(new /obj/item/gun/fiveseven(user), user.slot_in_backpack)
//				user.equip_if_possible(new /obj/item/gun/shotgun(user), user.slot_r_hand)
//				user.equip_if_possible(new /obj/item/gun/mp5(user), user.slot_l_hand)
//				user.equip_if_possible(new /obj/item/ammo/a57(user), user.slot_in_backpack)
				//var/obj/item/implant/sec/S = new /obj/item/implant/sec(user)
				//S.implanted = 1
				//S.implanted(user)
				//S.owner = src
				//user.implant.Add(S)

			else
				return


/proc/bust_lights()
	for(var/obj/machinery/light/lights in machines)
		if(prob(70))
			lights.on = 0
			lights.status = LIGHT_BROKEN
			lights.update()
	for(var/obj/machinery/power/apc/apcs in machines)
		if(prob(65))
			apcs.cell.charge-=20
	return

/proc/creepify_station()
	for(var/turf/simulated/floor/F in world)
		if (was_eaten)
			F.icon_state = "bloodfloor_2"
			F.name = "fleshy floor"
		else
			F.icon_state = pick("platingdmg1","platingdmg2","platingdmg3")
	for(var/turf/simulated/wall/W in world)
		if (was_eaten)
			W.icon = 'icons/misc/meatland.dmi'
			W.icon_state = "bloodwall_2"
			W.name = "meaty wall"
		else
			if(!istype(W, /turf/simulated/wall/r_wall) && !istype(W, /turf/simulated/wall/auto/reinforced))
				W.icon_state = "r_wall-4"
	return
