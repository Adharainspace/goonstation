/obj/machinery/power/void_collector
	name = "void energy collector"
	desc = "some sort of pole that naturally attracts void particles"
	icon = 'icons/obj/machines/voidengine.dmi'
	icon_state = "voidpole"
	density = 1
	anchored = 1
	var/power_amt = 1000
	var/on = 0

	process()
		if (src.on)
			src.add_avail(src.power_amt)
			flick("voidpole_succ", src)
			..()

	attack_hand(var/mob/M)
		boutput(M, "you flip the on switch")
		src.on = !src.on

	get_desc()
		. += "its [src.on ? "on" : "off"]"

/obj/machinery/void_laser_emitter
	name = "void shooter"
	desc = "shoots"
	icon = 'icons/obj/machines/voidengine64x32.dmi'
	icon_state = "laser_start-unc"
	bound_x = 64
	anchored = 1
	density = 1
	var/obj/machinery/power/terminal/terminal = null
	var/load_last_tick = 0
	var/consuming = 0 //are we consuming power
	var/consume_amt = 1000 //how much power are we eating
	var/pow_amt = 0 //how much power is stored

	New()
		..()
		var/turf/T = get_turf(src)
		src.terminal = locate(/obj/machinery/power/terminal) in T
		if (!src.terminal)
			T = get_step(src, EAST)
			src.terminal = locate(/obj/machinery/power/terminal) in T
		if (src.terminal)
			src.terminal.master = src

	disposing()
		if (src.terminal)
			src.terminal.master = null
			src.terminal = null
		..()

	get_desc()
		. += "It has [src.pow_amt] watts of electricity stored."
		. += " It is [src.consuming ? "off" : "on"]"

	attack_hand(var/mob/M)
		boutput(M, "you flip the consumption switch")
		src.consuming = !src.consuming

	process()
		if (src.consuming)
			var/llt = src.load_last_tick
			var/excess = (src.terminal.surplus() + llt)
			if (excess >= src.consume_amt)
				src.pow_amt += src.consume_amt
				src.load_last_tick = src.consume_amt
				src.add_load(src.consume_amt)
			else
				src.load_last_tick = 0
		else
			src.load_last_tick = 0

	proc/add_load(var/load_amt)
		if (src.terminal && src.terminal.powernet)
			src.terminal.powernet.newload += load_amt
