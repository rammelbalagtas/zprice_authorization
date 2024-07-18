@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Price Authorization'
define root view entity ZR_PR_AUTH_HEAD
  as select from ZI_PR_AUTH_HEAD
  composition [0..*] of ZR_PR_AUTH_ITEM as _Item
{
  key PriceAuth,
      HighPriority,
      Description,
      ValidFrom,
      ValidTo,
      Status,
      cast( case when Status is initial then 'Draft'
                 when Status = '03' then 'Submitted'
      else 'Pending status mapping'
      end as abap.char( 50 ) ) as StatusText,
      SubmittedTo,
      Notify,
      AttachmentUpload,
      MimeTypeUpload,
      FilenameUpload,
      AttachmentDownload,
      MimeTypeDownload,
      FilenameDownload,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      _Item
}
