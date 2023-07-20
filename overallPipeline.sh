echo "STARTING BUTYRATE!"

cd butyrate_rerun

nohup bash bowtieFullPipeline.sh

cd ..

echo "END BUTYRATE!"

echo "_____________________________________________________________________"
echo "(ﾉ^ヮ^)ﾉ*:・ﾟ✧ (ﾉ^ヮ^)ﾉ*:・ﾟ✧ (ﾉ^ヮ^)ﾉ*:・ﾟ✧ (ﾉ^ヮ^)ﾉ*:・ﾟ✧ (ﾉ^ヮ^)ﾉ*:・ﾟ✧"
echo -e "\n"

echo "START PROPIONATE"

cd propionate_rerun

nohup bash bowtieFullPipeline.sh

cd ..

echo "END PROPIONATE. EVERYTHING IS COMPLETED"
echo "＼＼\\٩(˃̶͈̀௰˂̶͈́)و //／／"