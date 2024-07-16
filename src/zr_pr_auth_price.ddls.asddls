@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Price'
define view entity ZR_PR_AUTH_PRICE
  as select from ZI_PR_AUTH_PRICE
  association        to parent ZR_PR_AUTH_ITEM as _Item   on  $projection.PriceAuth = _Item.PriceAuth
                                                          and $projection.Material  = _Item.Material
  association [0..1] to ZR_PR_AUTH_HEAD        as _Header on  $projection.PriceAuth = _Header.PriceAuth
{
  key PriceAuth,
  key Material,
  key CondType,
      PriceNew,
      PriceCurr,
      Currency,
      DealerMargin,
      PCIMargin,
      Scale1,
      Scale1Price,
      Scale2,
      Scale2Price,
      Scale3,
      Scale3Price,
      Scale4,
      Scale4Price,
      Scale5,
      Scale5Price,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      _Item,
      _Header
}
