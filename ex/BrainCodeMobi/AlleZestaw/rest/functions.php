<?php

function objectToArray($d) {
    if (is_object($d)) {
        // Gets the properties of the given object
        // with get_object_vars function
        $d = get_object_vars($d);
    }

    if (is_array($d)) {
        /*
         * Return array converted to object
         * Using __FUNCTION__ (Magic constant)
         * for recursive call
         */
        return array_map(__FUNCTION__, $d);
    } else {
        // Return array
        return $d;
    }
}

function doSearch($search, $allegroApi) {
    $list = $allegroApi->Search($search);
    //var_dump($list);
    $arr = objectToArray($list->searchArray->item);
    //var_dump($arr);
    $products = array();
    /* foreach ($arr as $product) {
      $productDTO = array();
      $productDTO['name'] = $product['sItName'];
      $productDTO['id'] = $product['sItId'];
      $productDTO['imgUrl'] = $product['sItThumbUrl'];
      $productDTO['buyNowPrice'] = $product['sItBuyNowPrice'];
      $productDTO['sellerId'] = $product['sItSellerInfo']['sellerId'];
      array_push($products, $productDTO);
      } */
    return $arr;
}

function productDTO($product) {
    $productDTO = array();
    $productDTO['name'] = $product['sItName'];
    $productDTO['id'] = $product['sItId'];
    $productDTO['imgUrl'] = $product['sItThumbUrl'];
    $productDTO['buyNowPrice'] = $product['sItBuyNowPrice'];
    return $productDTO;
}

function searchArr($arr) {
    return array_merge(array(
        //'search-query' => null,
        'searchOptions' => 8|128|16384,
        'searchOrder' => 4,
        'searchOrder-type' => 0,
        'searchCountry' => 0,
        'searchCategory' => 0,
        'searchOffset' => 0,
        'searchCity' => '',
        'searchState' => null,
        'searchPriceFrom' => 0.00,
        'searchPriceTo' => 30000.00,
        'searchLimit' => 1,
        'searchOrderFulfillmentTime' => 96,
        'searchUser' => null
            ), $arr);
}

function startsWith($haystack, $needle) {
    return $needle === "" || strpos($haystack, $needle) === 0;
}

function endsWith($haystack, $needle) {
    return $needle === "" || substr($haystack, -strlen($needle)) === $needle;
}
