local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.items then EnKai.items = {} end

privateVars.items = {}

privateVars.items.itemTypeTranslation = { ['twohanded:staff'] = privateVars.langTexts.items.txtStaff,
							['twohanded:hammer'] = privateVars.langTexts.items.txtTwoHand .. ' ' .. privateVars.langTexts.items.txtHammer, 
							['twohanded:polearm'] = privateVars.langTexts.items.txtTwoHand .. ' ' .. privateVars.langTexts.items.txtPolearm, 
							['twohanded:sword'] = privateVars.langTexts.items.txtTwoHand .. ' ' .. privateVars.langTexts.items.txtSword, 
							['twohanded:axe'] = privateVars.langTexts.items.txtTwoHand .. ' ' .. privateVars.langTexts.items.txtAxe, 
							['twohanded:mace'] = privateVars.langTexts.items.txtTwoHand .. ' ' .. privateVars.langTexts.items.txtMace, 
							['essence:lesser'] = privateVars.langTexts.items.txtEssenceLesser, 
							['essence:greater'] = privateVars.langTexts.items.txtEssenceGreater, 
							['mainhand:sword'] = privateVars.langTexts.items.txtMainhand .. ' ' .. privateVars.langTexts.items.txtSword, 
							['mainhand:mace'] = privateVars.langTexts.items.txtMainhand .. ' ' .. privateVars.langTexts.items.txtMace, 
							['mainhand:dagger'] = privateVars.langTexts.items.txtMainhand .. ' ' .. privateVars.langTexts.items.txtDagger,
							['mainhand:axe'] = privateVars.langTexts.items.txtMainhand .. ' ' .. privateVars.langTexts.items.txtAxe,
							['onehanded:axe'] = privateVars.langTexts.items.txtOneHand .. ' ' .. privateVars.langTexts.items.txtAxe, 
							['onehanded:sword'] = privateVars.langTexts.items.txtOneHand .. ' ' .. privateVars.langTexts.items.txtSword, 
							['onehanded:mace'] = privateVars.langTexts.items.txtOneHand .. ' ' .. privateVars.langTexts.items.txtMace, 
							['onehanded:dagger'] = privateVars.langTexts.items.txtOneHand .. ' ' .. privateVars.langTexts.items.txtDagger, 
							['ranged:wand_life'] = privateVars.langTexts.items.txtWand, 
							['ranged:wand_air'] = privateVars.langTexts.items.txtWand, 
							['ranged:wand_fire'] = privateVars.langTexts.items.txtWand, 
							['ranged:wand_water'] = privateVars.langTexts.items.txtWand, 
							['ranged:wand_earth'] = privateVars.langTexts.items.txtWand, 
							['ranged:wand'] = privateVars.langTexts.items.txtWand, 
							['ranged:gun'] = privateVars.langTexts.items.txtGun, 
							['ranged:bow'] = privateVars.langTexts.items.txtBow,
							['helmet:plate'] = privateVars.langTexts.items.txtHelmet .. ' ' .. privateVars.langTexts.items.txtPlate, 
							['helmet:chain'] = privateVars.langTexts.items.txtHelmet .. ' ' .. privateVars.langTexts.items.txtChain, 
							['helmet:leather'] = privateVars.langTexts.items.txtHelmet .. ' ' .. privateVars.langTexts.items.txtLeather, 
							['helmet:cloth'] = privateVars.langTexts.items.txtHelmet .. ' ' .. privateVars.langTexts.items.txtCloth,
							['shoulders:plate'] = privateVars.langTexts.items.txtShoulders .. ' ' .. privateVars.langTexts.items.txtPlate, 
							['shoulders:chain'] = privateVars.langTexts.items.txtShoulders .. ' ' .. privateVars.langTexts.items.txtChain, 
							['shoulders:leather'] = privateVars.langTexts.items.txtShoulders .. ' ' .. privateVars.langTexts.items.txtLeather, 
							['shoulders:cloth'] = privateVars.langTexts.items.txtShoulders .. ' ' .. privateVars.langTexts.items.txtCloth,
							['chest:plate'] = privateVars.langTexts.items.txtChest .. ' ' .. privateVars.langTexts.items.txtPlate, 
							['chest:chain'] = privateVars.langTexts.items.txtChest .. ' ' .. privateVars.langTexts.items.txtChain, 
							['chest:leather'] = privateVars.langTexts.items.txtChest .. ' ' .. privateVars.langTexts.items.txtLeather, 
							['chest:cloth'] = privateVars.langTexts.items.txtChest .. ' ' .. privateVars.langTexts.items.txtCloth, 
							['gloves:plate'] = privateVars.langTexts.items.txtGloves .. ' ' .. privateVars.langTexts.items.txtPlate, 
							['gloves:chain'] = privateVars.langTexts.items.txtGloves .. ' ' .. privateVars.langTexts.items.txtChain, 
							['gloves:leather'] = privateVars.langTexts.items.txtGloves .. ' ' .. privateVars.langTexts.items.txtLeather, 
							['gloves:cloth'] = privateVars.langTexts.items.txtGloves .. ' ' .. privateVars.langTexts.items.txtCloth,
							['belt:plate'] = privateVars.langTexts.items.txtBelt .. ' ' .. privateVars.langTexts.items.txtPlate, 
							['belt:chain'] = privateVars.langTexts.items.txtBelt .. ' ' .. privateVars.langTexts.items.txtChain, 
							['belt:leather'] = privateVars.langTexts.items.txtBelt .. ' ' .. privateVars.langTexts.items.txtLeather, 
							['belt:cloth'] = privateVars.langTexts.items.txtBelt .. ' ' .. privateVars.langTexts.items.txtCloth,
							['legs:plate'] = privateVars.langTexts.items.txtLegs .. ' ' .. privateVars.langTexts.items.txtPlate, 
							['legs:chain'] = privateVars.langTexts.items.txtLegs .. ' ' .. privateVars.langTexts.items.txtChain, 
							['legs:leather'] = privateVars.langTexts.items.txtLegs .. ' ' .. privateVars.langTexts.items.txtLeather, 
							['legs:cloth'] = privateVars.langTexts.items.txtLegs .. ' ' .. privateVars.langTexts.items.txtCloth,
							['feet:plate'] = privateVars.langTexts.items.txtFeet .. ' ' .. privateVars.langTexts.items.txtPlate, 
							['feet:chain'] = privateVars.langTexts.items.txtFeet .. ' ' .. privateVars.langTexts.items.txtChain, 
							['feet:leather'] = privateVars.langTexts.items.txtFeet .. ' ' .. privateVars.langTexts.items.txtLeather, 
							['feet:cloth'] = privateVars.langTexts.items.txtFeet .. ' ' .. privateVars.langTexts.items.txtCloth, 
							['ring:items'] = privateVars.langTexts.items.txtRing, 
							['offhand:items'] = privateVars.langTexts.items.txtOffhand, 
							['neck:items'] = privateVars.langTexts.items.txtNeck, 
							['shield:items'] = privateVars.langTexts.items.txtShield, 
							['trinket:items'] = privateVars.langTexts.items.txtTrinket,
							['pets:items'] = privateVars.langTexts.items.txtPet, 
							['currency:items'] = privateVars.langTexts.items.txtCurrency, 
							['mount:items'] = privateVars.langTexts.items.txtMount, 
							['other:items'] = privateVars.langTexts.items.txtOther,
							['synergycrystal:items'] = privateVars.langTexts.items.txtSynergyCrystal, 
							['focus:items'] = privateVars.langTexts.items.txtFocus,
							['recipe:artificer'] = privateVars.langTexts.items.txtRecipe .. ' ' .. privateVars.langTexts.profession.txtArtificer,  
							['recipe:runecrafter'] = privateVars.langTexts.items.txtRecipe .. ' ' .. privateVars.langTexts.profession.txtRunecrafter, 
							['recipe:weaponsmith'] = privateVars.langTexts.items.txtRecipe .. ' ' .. privateVars.langTexts.profession.txtWeaponsmith, 
							['recipe:outfitter'] = privateVars.langTexts.items.txtRecipe .. ' ' .. privateVars.langTexts.profession.txtOutfitter,  
							['recipe:armorsmith'] = privateVars.langTexts.items.txtRecipe .. ' ' .. privateVars.langTexts.profession.txtArmorsmith,
							['recipe:alchemist'] = privateVars.langTexts.items.txtRecipe .. ' ' .. privateVars.langTexts.profession.txtApothecary, 
							['consumable:lure'] = privateVars.langTexts.items.txtLure, 
							['consumable:husk'] = privateVars.langTexts.items.txtHusk, 
							['consumable:runes'] = privateVars.langTexts.items.txtRune, 
							['consumable:food'] = privateVars.langTexts.items.txtConsumable,
							['consumable:vial'] = privateVars.langTexts.items.txtConsumable, 
							['consumable:generic'] = privateVars.langTexts.items.txtConsumable, 
							['consumable:potion'] = privateVars.langTexts.items.txtConsumable, 
							['consumable:weaponenchant'] = privateVars.langTexts.items.txtConsumable, 
							['costume:helmet'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtHelmet, 
							['costume:shoulders'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtShoulders, 
							['costume:chest'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtChest, 
							['costume:legs'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtLegs,
							['costume:onehanded'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtOneHand, 
							['costume:twohanded'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtTwoHand, 
							['costume:feet'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtFeet, 
							['costume:gloves'] = privateVars.langTexts.items.txtCostume .. ' ' .. privateVars.langTexts.items.txtGloves, 
							['title:items'] = privateVars.langTexts.items.txtTitle,
							['container:items'] = privateVars.langTexts.items.txtContainer,
							['seal:items'] = privateVars.langTexts.items.txtSeal,
							['cape:items'] = privateVars.langTexts.items.txtCape .. ' ' .. privateVars.langTexts.items.txtCloth,
							['cape:cloth'] = privateVars.langTexts.items.txtCape .. ' ' .. privateVars.langTexts.items.txtCloth,
							['consumable:upgradeitem'] = privateVars.langTexts.items.txtConsumable,
							['dimension:items'] = privateVars.langTexts.items.txtDimension,
							['consumable:rune'] = privateVars.langTexts.items.txtRune, 
							['consumable:itemupgrade'] = privateVars.langTexts.items.txtItemUpgrade,
							['misc:other'] = privateVars.langTexts.items.txtOther
}

privateVars.items.riftCategoryToType = { 	['weapon onehand dagger'] = 'onehanded:dagger', ['weapon onehand axe'] = 'onehanded:axe', ['weapon onehand mace'] = 'onehanded:mace', ['weapon onehand sword'] = 'onehanded:sword',
							['weapon ranged bow'] = 'ranged:bow', ['weapon ranged gun'] = 'ranged:gun', ['weapon ranged wand'] = 'ranged:wand', ['weapon totem'] = 'offhand:items', 
							['weapon twohand staff'] = 'twohanded:staff', ['weapon twohand sword'] = 'twohanded:sword', ['weapon twohand hammer'] = 'twohanded:hammer', ['weapon twohand polearm'] = 'twohanded:polearm', ['weapon twohand axe'] = 'twohanded:axe', ['weapon twohand mace'] = 'twohanded:mace', 
							['armor leather head'] = 'helmet:leather', ['armor leather chest'] = 'chest:leather', ['armor leather shoulders'] = 'shoulders:leather', ['armor leather hands'] = 'gloves:leather', ['armor leather waist'] = 'belt:leather', ['armor leather legs'] = 'legs:leather', ['armor leather feet'] = 'feet:leather',
							['armor chain head'] = 'helmet:chain', ['armor chain chest'] = 'chest:chain', ['armor chain shoulders'] = 'shoulders:chain', ['armor chain hands'] = 'gloves:chain', ['armor chain waist'] = 'belt:chain', ['armor chain legs'] = 'legs:chain', ['armor chain feet'] = 'feet:chain',
							['armor plate head'] = 'helmet:plate', ['armor plate chest'] = 'chest:plate', ['armor plate shoulders'] = 'shoulders:plate', ['armor plate hands'] = 'gloves:plate', ['armor plate waist'] = 'belt:plate', ['armor plate legs'] = 'legs:plate', ['armor plate feet'] = 'feet:plate',
							['armor cloth head'] = 'helmet:cloth', ['armor cloth chest'] = 'chest:cloth', ['armor cloth shoulders'] = 'shoulders:cloth', ['armor cloth hands'] = 'gloves:cloth', ['armor cloth waist'] = 'belt:cloth', ['armor cloth legs'] = 'legs:cloth', ['armor cloth feet'] = 'feet:cloth',
							['armor accessory ring'] = 'ring:items', ['armor accessory neck'] = 'neck:items', ['armor accessory trinket'] = 'trinket:items', ['armor cape'] = 'cape:items',
							['planar lesser'] = 'essence:lesser',['planar greater'] = 'essence:greater', ['weapon shield'] = 'shield:items', ['armor accessory seal'] = 'seal:items',
							['misc pet'] = 'pets:items', ['consumable enchantment'] = 'consumable:rune', ['misc other'] = 'misc:other', ['consumable food'] = 'consumable:food', ['consumable consumable'] = 'consumable:generic'
						}
						
						
function EnKai.items.getRessource (ID, subID) 

	if subID == nil then
		return privateVars.items[ID]
	else
		return privateVars.items[ID][subID]
	end
		
end

function EnKai.items.translateRiftCategory (ID) 

	if ID == nil then return nil end

	local retValue = privateVars.items.riftCategoryToType[ID]
	
	if retValue == nil then
		if string.find(ID, 'dimension') == 1 then
			retValue = 'dimension:items'
		elseif string.find(ID, 'crafting') == 1 then
			local profession = string.sub(ID, string.len("crafting recipe")+2)
			if profession == 'apothecary' then profession = 'alchemist' end
			if profession == 'runecrafting' then profession = 'runecrafter' end
			retValue = 'recipe:' .. profession
		end
	end
	
	return retValue
		
end