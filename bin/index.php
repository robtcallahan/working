<?php

/**
 * Sign a private asset url on cloudfront
 *
 * @param $resource full url of the resources
 * @param $timeout timeout in seconds
 * @return string signed url
 * @throws Exception
 */
function getSignedURL($resource, $timeout)
{
    // This is the id of the Cloudfront key pair you generated
    $keyPairId = "APKAJJTOC4Y3ZB2VD7XQ";

    $expires = time() + $timeout; // Timeout in seconds
    $json = '{"Statement":[{"Resource":"'.$resource.'","Condition":{"DateLessThan":{"AWS:EpochTime":'.$expires.'}}}]}';

    // Read Cloudfront Private Key Pair, do not place it in the webroot!
    $fp = fopen("/var/www/html/cloudfront.pem", "r");
    $priv_key = fread($fp,8192);
    fclose($fp);

    // Create the private key
    $key = openssl_get_privatekey($priv_key);
    if (!$key) {
        throw new Exception('Loading private key failed');
    }

    // Sign the policy with the private key
    if (!openssl_sign($json, $signed_policy, $key, OPENSSL_ALGO_SHA1)) {
        throw new Exception('Signing policy failed, '.openssl_error_string());
    }

    // Create url safe signed policy
    $base64_signed_policy = base64_encode($signed_policy);
    $signature = str_replace(array('+','=','/'), array('-','_','~'), $base64_signed_policy);

    // Construct the URL
    $url = $resource .  (strpos($resource, '?') === false ? '?' : '&') . 'Expires='.$expires.'&Signature=' . $signature . '&Key-Pair-Id=' . $keyPairId;
    return $url;
}

// Example usage
echo "<h3>Image File Example</h3>";
$signed_url = getSignedURL("https://d8lkzio2al7h7.cloudfront.net/rob/git_merge.gif", 60);
echo '<b>Starting URL (Resource):</b> http://d8lkzio2al7h7.cloudfront.net/rob/git_merge.gif<br><br>';
echo '<b>Canned Policy:</b> <pre>{
  "Statement":
    [
      {
        "Resource": "http://d8lkzio2al7h7.cloudfront.net/rob/git_merge.gif",
        "Condition": {
            "DateLessThan": {
                "AWS:EpochTime": 1543262281
              }
          }
      }
    ]
}</pre><br>';
echo '<b>Signed URL:</b> ' . $signed_url . '<br><br>';
echo '<b>Signed Link:</b> <a href="' . $signed_url . '">Git Merge</a><br><br>';

echo "<hr><h3>EVO Example</h3>";
$signed_url = getSignedURL("https://d8lkzio2al7h7.cloudfront.net/iDX%204.1.1.2/Hub%20Packages.zip", 60);
echo '<b>Starting URL (Resource):</b> http://d8lkzio2al7h7.cloudfront.net/iDX%204.1.1.2/Hub%20Packages.zip<br><br>';
echo '<b>Canned Policy:</b> <pre>{
  "Statement":
    [
      {
        "Resource": "http://d8lkzio2al7h7.cloudfront.net/iDX%204.1.1.2/Hub%20Packages.zip",
        "Condition": {
            "DateLessThan": {
                "AWS:EpochTime": 1543262281
              }
          }
      }
    ]
}</pre><br>';
echo '<b>Signed URL:</b> ' . $signed_url . '<br><br>';
echo '<b>Signed Link:</b> <a href="' . $signed_url . '">iDX 4.1.1.2/Hub Packages.zip</a><br><br>';
