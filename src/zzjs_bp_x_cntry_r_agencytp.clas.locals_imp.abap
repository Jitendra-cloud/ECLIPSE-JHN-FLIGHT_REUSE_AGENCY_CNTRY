CLASS lhc_agency DEFINITION INHERITING FROM cl_abap_behavior_handler.


  PUBLIC SECTION.

    CONSTANTS:
    validate_dialling_code    TYPE string VALUE 'VALIDATE_DIALLING_CODE' ##NO_TEXT.

    TYPES: BEGIN OF t_countries,
             number TYPE zjs_de_phone_number,
             code   TYPE land1,
           END OF t_countries.

    CLASS-DATA: countries TYPE STANDARD TABLE OF t_countries WITH KEY number.
    CLASS-METHODS: class_constructor.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Agency RESULT result.

    METHODS zzcreateFromTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Agency~zzcreateFromTemplate.

ENDCLASS.

CLASS lhc_agency IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD zzcreateFromTemplate.
    READ ENTITIES OF ZJS_I_AgencyTP IN LOCAL MODE
      ENTITY Agency
        FIELDS ( CountryCode PostalCode City Street ) WITH CORRESPONDING #( keys )
      RESULT DATA(agencies)
      FAILED failed.

    DATA: agencies_to_create TYPE TABLE FOR CREATE ZJS_I_AgencyTP.
    LOOP AT agencies INTO DATA(agency).
      APPEND CORRESPONDING #( agency EXCEPT agencyid ) TO agencies_to_create ASSIGNING FIELD-SYMBOL(<agency_to_create>).
      <agency_to_create>-%cid = keys[ KEY id  %tky = agency-%tky ]-%cid.
      <agency_to_create>-%is_draft = if_abap_behv=>mk-on.
    ENDLOOP.

    MODIFY ENTITIES OF ZJS_I_AgencyTP IN LOCAL MODE
      ENTITY Agency
        CREATE FIELDS ( CountryCode PostalCode City Street ) WITH agencies_to_create
      MAPPED mapped.
  ENDMETHOD.

  METHOD class_constructor.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
