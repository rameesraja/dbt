import inflection

str = """SELECT
    substr(MerchandiserRouteCode,1,4) as Plant,
    substr(MerchandiserRouteCode,5,3) as RouteNumber,
    MerchandiserRouteCode,
    MerchandiserRouteName,
    MerchandiserRouteManagerEmployeeNumber,
    '' AS MerchandiserRouteManagerEmployeeName,
    SupervisorGroupCode,
    SupervisorGroupName,
    SupervisorGroupManagerEmployeeNumber,
    '' AS SupervisorGroupManagerEmployeeName,
    DistributionManagerAreaCode,
    DistributionManagerAreaName,
    DistributionManagerAreaManagerEmployeeNumber,
    '' AS DistributionManagerAreaManagerEmployeeName,
    SeniorDirectorFieldOperationsAreaCode,
    SeniorDirectorFieldOperationsAreaName,
    SeniorDirectorFieldOperationsAreaManagerEmployeeNumber,
    '' AS SeniorDirectorFieldOperationsAreaManagerEmployeeName,
    RegionMarketUnitCode,
    RegionMarketUnitName,
    RegionMarketUnitManagerEmployeeNumber,
    '' AS RegionMarketUnitManagerEmployeeName,
    VPFieldOperationsAreaCode,
    VPFieldOperationsAreaName,
    VPFieldOperationsAreaManagerEmployeeNumber,
    '' AS VPFieldOperationsAreaManagerEmployeeName,
    TotalCorpCode,
    TotalCorpName,
    TotalCorpManagerEmployeeNumber,
    '' AS TotalCorpManagerEmployeeName,
    ETLCONTROLID,
    INSERTDATE,
    MODIFIEDDATE

FROM HierDelivery"""

print(inflection.underscore(str))