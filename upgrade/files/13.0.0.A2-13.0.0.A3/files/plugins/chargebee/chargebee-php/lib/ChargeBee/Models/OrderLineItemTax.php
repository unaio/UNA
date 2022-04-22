<?php

namespace ChargeBee\ChargeBee\Models;

use ChargeBee\ChargeBee\Model;

class OrderLineItemTax extends Model
{
  protected $allowed = [
    'lineItemId',
    'taxName',
    'taxRate',
    'isPartialTaxApplied',
    'isNonComplianceTax',
    'taxableAmount',
    'taxAmount',
    'taxJurisType',
    'taxJurisName',
    'taxJurisCode',
    'taxAmountInLocalCurrency',
    'localCurrencyCode',
  ];

}

?>