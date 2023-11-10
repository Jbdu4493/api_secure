#/bin/sh

# générer une clé privée
openssl genrsa -out my_private.key 2048

# générer la clé publique correspondante
openssl rsa -in my_private.key -pubout -out my_public.key

wget https://dst-de.s3.eu-west-3.amazonaws.com/api_security_theory_en/keys/alice_public.key
wget https://dst-de.s3.eu-west-3.amazonaws.com/api_security_theory_en/keys/alice_private.key
wget https://dst-de.s3.eu-west-3.amazonaws.com/api_security_theory_en/keys/bob_public.key
wget https://dst-de.s3.eu-west-3.amazonaws.com/api_security_theory_en/keys/bob_private.key
wget https://dst-de.s3.eu-west-3.amazonaws.com/api_security_theory_en/keys/clementine_public.key
wget https://dst-de.s3.eu-west-3.amazonaws.com/api_security_theory_en/keys/clementine_private.key

echo "Hi Bob" > my_message.txt
openssl pkeyutl \
 -encrypt \
 -pubin \
 -inkey bob_public.key \
 -in my_message.txt > encrypted_message_for_bob 

# impression du contenu du message crypté
echo "_____Message Encrypt pour Bob_____"
cat encrypted_message_for_bob


openssl pkeyutl \
 -decrypt \
 -inkey bob_private.key \
 -in encrypted_message_for_bob



openssl pkeyutl \
-decrypt \
-inkey alice_private.key \
-in encrypted_message_for_bob


openssl pkeyutl -sign \
 -inkey alice_private.key \
 -in my_hash.txt \
 -out alice_signature.txt

echo "_____Message Decrypt pour Bob_____"

 openssl pkeyutl -verify \
 -pubin \
 -inkey alice_public.key \
 -in alice_signature.txt

 openssl pkeyutl -verify \
 -pubin \
 -inkey alice_public.key \
 -in alice_signature.txt

openssl pkeyutl \
 -decrypt \
 -inkey bob_private.key \
 -in encrypted_message_for_bob | md5sum