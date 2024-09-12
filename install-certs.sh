#!/usr/bin/bash
wget \
        --level=1 \
        --quiet \
        --recursive \
        --no-parent \
        --no-host-directories \
        --no-directories \
        --accept="VA*.cer" \
        http://aia.pki.va.gov/PKI/AIA/VA/
CA_CERTS=(
  VA-Internal-S2-RCA2.cer
  VA-Internal-S2-RCA1-v1.cer
  VA-Internal-S2-ICA4.cer
  VA-Internal-S2-ICA5.cer
  VA-Internal-S2-ICA6.cer
  VA-Internal-S2-ICA7.cer
  VA-Internal-S2-ICA8.cer
  VA-Internal-S2-ICA9.cer
  VA-Internal-S2-ICA10.cer
  VA-Internal-S2-ICA1-v1.cer
  VA-Internal-S2-ICA2-v1.cer
  VA-Internal-S2-ICA3-v1.cer
  VA-Internal-S2-ICA11.cer
  VA-Internal-S2-ICA12.cer
  VA-Internal-S2-ICA13.cer
  VA-Internal-S2-ICA14.cer
  VA-Internal-S2-ICA15.cer
  VA-Internal-S2-ICA16.cer
  VA-Internal-S2-ICA17.cer
  VA-Internal-S2-ICA18.cer
  VA-Internal-S2-ICA19.cer
  VA-Internal-S2-ICA20.cer
  VA-Internal-S2-ICA21.cer
 )
ANCHORS=/usr/local/share/ca-certificates
for CERT in ${CA_CERTS[@]}
do
  OUT=$ANCHORS/${CERT##*/}
 echo "Copying $CERT to $OUT"
  cp $CERT $OUT
done
for cert in $(find $ANCHORS -type f -name "*.cer")
  do
    echo "Combining $cert"
    out_name="${cert%.*}"
    openssl x509 -in $cert -out $out_name.crt
    chmod 0444 $out_name.crt
  done
echo "Installed CA certs."
update-ca-certificates -f
