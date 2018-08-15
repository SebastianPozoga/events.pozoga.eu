<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

require 'AllegroApi.php';
require 'functions.php';
require 'passwords.php';

//header('Access-Control-Allow-Origin: *');
//header("Access-Control-Allow-Methods: POST, GET");
//header("Access-Control-Allow-Headers: x-requested-with");

try {
    //Init  API
    $allegroApi = new AllegroApi();
    $allegroApi->loginEnc();

    //get search strings
    $searchStrs = array();
    foreach ($_GET as $key => $searchString) {
        if (empty($searchString))
            continue;
        if (startsWith($key, "product")) {
            array_push($searchStrs, $searchString);
        }
    }
    $keywords = implode(", ", $searchStrs);

    //Input
    $maxResult = isset($_GET['limit']) ? $_GET['limit'] : 15;

    $firsSearchStr = array_pop($searchStrs);
    if (sizeof($firsSearchStr) == 0) {
        header("HTTP/1.0 404 Not Found");
        exit('{"error"":"Search string no found"}');
    }

    $searchArr = searchArr(array(
        'searchQuery' => array('searchString' => $searchString),
        'searchLimit' => $maxResult * 3)
    );
    $mainSet = doSearch($searchArr, $allegroApi);
    //var_dump($mainSet);
    
    $resultDTO = array();
    $resultDTO['keywords'] = $keywords;
    $groups = array();
    foreach ($mainSet as $firstItem) {
        $groupDTO = array();
        $groupDTO['sellerId'] = $firstItem['sItSellerInfo']['sellerId'];
        $groupDTO['sellerName'] = $firstItem['sItSellerInfo']['sellerName'];

        $price = $firstItem['sItBuyNowPrice'];
        $productsDTO = array();
        array_push($productsDTO, productDTO($firstItem));
        foreach ($searchStrs as $key => $searchString) {
            $searchArr = searchArr(array(
                'searchQuery' => array('searchString' => $searchString),
                'searchLimit' => 1,
                'searchUser' => $firstItem['sItSellerInfo']['sellerId'])
            );
            $list = doSearch($searchArr, $allegroApi);

            if (!isset($list[0])) {
                //if no find all search string no create group
                continue 2;
            }
            $product = $list[0];
            $price += $product['sItBuyNowPrice'];
            $productDTO = productDTO($product);
            array_push($productsDTO, $productDTO);
            //var_dump($productDTO);
        }
        //$groupDTO['sellerName'] = $firstItem['sellerName'];
        $groupDTO['totalPrice'] = $price;
        $groupDTO['products'] = $productsDTO;
        array_push($groups, $groupDTO);
        $maxResult--;
        if ($maxResult <= 0)
            break;
    }

    $resultDTO['groups'] = $groups;
    echo json_encode($resultDTO);
} catch (Exception $e) {
    echo $e;
}
