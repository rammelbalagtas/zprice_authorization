@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Items'
define view entity ZR_PR_AUTH_ITEM
  as select from ZI_PR_AUTH_ITEM
  association to parent ZR_PR_AUTH_HEAD as _Header on $projection.PriceAuth = _Header.PriceAuth
  composition [0..*] of ZR_PR_AUTH_PRICE as _Price
  composition [0..*] of ZR_PR_AUTH_CUST as _Customer
{
  key PriceAuth,
  key Material,
      Sequence,
      Reject,
      GmBudget,
      GmActual,
      EstoreFreeze,
      PriceProt,
      PpImpact,
      OnhandInc,
      OnhandIncImpact,
      Map,
      Status,
      Unit,
      Currency,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      _Header,
      _Price,
      _Customer
}
