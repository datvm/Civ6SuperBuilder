UPDATE Units SET BaseMoves = 4, BuildCharges = 6 WHERE UnitType = 'UNIT_BUILDER';
UPDATE Features SET AddCivic = 'CIVIC_STATE_WORKFORCE' WHERE FeatureType = 'FEATURE_FOREST';
UPDATE Features SET RemoveTech = NULL WHERE Removable = 1;
UPDATE Resource_Harvests SET PrereqTech = NULL;

INSERT INTO Improvement_ValidBuildUnits('ImprovementType', 'UnitType') VALUES ('IMPROVEMENT_FORT', 'UNIT_BUILDER');
INSERT INTO Improvement_ValidBuildUnits('ImprovementType', 'UnitType') VALUES ('IMPROVEMENT_AIRSTRIP', 'UNIT_BUILDER');
INSERT INTO Improvement_ValidBuildUnits('ImprovementType', 'UnitType') VALUES ('IMPROVEMENT_MISSILE_SILO', 'UNIT_BUILDER');
INSERT INTO Improvement_ValidBuildUnits('ImprovementType', 'UnitType') VALUES ('IMPROVEMENT_MOUNTAIN_TUNNEL', 'UNIT_BUILDER');

INSERT INTO Route_ValidBuildUnits('RouteType', 'UnitType') VALUES ('ROUTE_ANCIENT_ROAD', 'UNIT_BUILDER');
INSERT INTO Route_ValidBuildUnits('RouteType', 'UnitType') VALUES ('ROUTE_MEDIEVAL_ROAD', 'UNIT_BUILDER');
INSERT INTO Route_ValidBuildUnits('RouteType', 'UnitType') VALUES ('ROUTE_INDUSTRIAL_ROAD', 'UNIT_BUILDER');
INSERT INTO Route_ValidBuildUnits('RouteType', 'UnitType') VALUES ('ROUTE_MODERN_ROAD', 'UNIT_BUILDER');
INSERT INTO Route_ValidBuildUnits('RouteType', 'UnitType') VALUES ('ROUTE_RAILROAD', 'UNIT_BUILDER');

-- Ignore Terrain Cost
INSERT INTO Types (Type, Kind) VALUES
	('MODIFIER_BUILDER_IGNORE_TERRAIN_COST', 'KIND_MODIFIER');
INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES
	('MODIFIER_BUILDER_IGNORE_TERRAIN_COST', 'COLLECTION_PLAYER_UNITS', 'EFFECT_ADJUST_UNIT_IGNORE_TERRAIN_COST');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_LEADER_MAJOR_CIV', 'BUILDER_IGNORE_TERRAIN'),
	('TRAIT_LEADER_MAJOR_CIV', 'BUILDER_IGNORE_RIVERS'),
	('TRAIT_LEADER_MAJOR_CIV', 'BUILDER_IGNORE_EMBARK');
INSERT INTO Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) VALUES
	('BUILDER_IGNORE_TERRAIN', 'MODIFIER_BUILDER_IGNORE_TERRAIN_COST', 1, 'BUILDER_SPEED_REQSET'),
	('BUILDER_IGNORE_RIVERS', 'MODIFIER_PLAYER_UNITS_ADJUST_IGNORE_RIVERS', 1, 'BUILDER_SPEED_REQSET'),
	('BUILDER_IGNORE_EMBARK', 'MODIFIER_PLAYER_UNITS_ADJUST_IGNORE_SHORES', 1, 'BUILDER_SPEED_REQSET');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BUILDER_IGNORE_TERRAIN', 'Ignore', 1),
	('BUILDER_IGNORE_TERRAIN', 'Type', 'ALL'),
	('BUILDER_IGNORE_RIVERS', 'Ignore', 1),
	('BUILDER_IGNORE_EMBARK', 'Ignore', 1);
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
	('BUILDER_SPEED_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
	('BUILDER_SPEED_REQSET', 'REQUIRES_UNIT_IS_BUILDER');
INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES
	('REQUIRES_UNIT_IS_BUILDER', 'REQUIREMENT_UNIT_TYPE_MATCHES', 0);
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
	('REQUIRES_UNIT_IS_BUILDER', 'UnitType', 'UNIT_BUILDER');
	
-- Fishery without Governor
UPDATE Improvements SET TraitType = NULL WHERE ImprovementType = "IMPROVEMENT_FISHERY";

-- Earlier Forts for Human Players
---- Remove Fort from tech tree and buildable
UPDATE Improvements SET PrereqTech = NULL, TraitType = 'TRAIT_CIVILIZATION_NO_PLAYER' WHERE ImprovementType = 'IMPROVEMENT_FORT';

---- Requirement: is human or has Siege Tactics
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType, ProgressWeight) VALUES
	('REQUIRES_TECH_SIEGE_TACTICS', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY', 1);
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Type, Value) VALUES
	('REQUIRES_TECH_SIEGE_TACTICS', 'TechnologyType', 'ARGTYPE_IDENTITY', 'TECH_SIEGE_TACTICS');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('FORT_PLAYER_IS_HUMAN_OR_HAS_SIEGE_TACTICS', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('FORT_PLAYER_IS_HUMAN_OR_HAS_SIEGE_TACTICS', 'REQUIRES_PLAYER_IS_HUMAN'),
	('FORT_PLAYER_IS_HUMAN_OR_HAS_SIEGE_TACTICS', 'REQUIRES_TECH_SIEGE_TACTICS');

---- Modifiers: Grant Fort if requirements are met
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId) VALUES
	('GRANT_IMPROVEMENT_FORT', 'MODIFIER_PLAYER_ADJUST_VALID_IMPROVEMENT', 'FORT_PLAYER_IS_HUMAN_OR_HAS_SIEGE_TACTICS');
INSERT INTO ModifierArguments(ModifierId, Name, Type, Value) VALUES
	('GRANT_IMPROVEMENT_FORT', 'ImprovementType', 'ARGTYPE_IDENTITY', 'IMPROVEMENT_FORT');
	
---- Grant modifier for every major civ
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_LEADER_MAJOR_CIV', 'GRANT_IMPROVEMENT_FORT');