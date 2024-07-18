@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Authorization - Customer'

define view entity ZI_PR_AUTH_CUST
  as select from zpr_auth_cust
{
      @EndUserText.label : 'PR Auth'
  key price_auth         as PriceAuth,
      @EndUserText.label : 'Material'
  key material           as Material,
      @EndUserText.label : 'Customer'
  key customer           as Customer,
      @EndUserText.label : 'Condition Type'
      cond_type          as CondType,
      @EndUserText.label : 'New'
      price_new          as PriceNew,
      @EndUserText.label : 'Dealer Margin'
      dealer_margin      as DealerMargin,
      @EndUserText.label : 'PCI Margin'
      pci_margin         as PCIMargin,
      @EndUserText.label : 'Currency'
      currency           as Currency,
      @Semantics.user.createdBy: true
      localcreatedby     as Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      localcreatedat     as Localcreatedat,
      @Semantics.user.localInstanceLastChangedBy: true
      locallastchangedby as Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat
}
