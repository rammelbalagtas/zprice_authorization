@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customers'
define view entity ZR_PR_AUTH_CUST
  as select from ZI_PR_AUTH_CUST
  association        to parent ZR_PR_AUTH_ITEM as _Item   on  $projection.PriceAuth = _Item.PriceAuth
                                                          and $projection.Material  = _Item.Material
  association [0..1] to ZR_PR_AUTH_HEAD        as _Header on  $projection.PriceAuth = _Header.PriceAuth
{
  key PriceAuth,
  key Material,
  key CondType,
  key Customer,
      PriceNew,
      Currency,
      DealerMargin,
      PCIMargin,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      _Item,
      _Header
}
