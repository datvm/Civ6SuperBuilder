UPDATE Units SET BaseMoves = 4, BuildCharges = 6 WHERE UnitType = 'UNIT_BUILDER';
UPDATE Improvements SET PrereqTech = NULL WHERE ImprovementType = 'IMPROVEMENT_FORT';
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