@EndUserText.label: 'Abstract entity for Supplier'
@Metadata.allowExtensions: true
define root abstract entity zpr_auth_item_notes
 {
    @UI.defaultValue : #( 'ELEMENT_OF_REFERENCED_ENTITY: Notes')
    @UI.multiLineText: true
    @EndUserText.label: 'Notes'
    Notes : abap.string(0);  
}
