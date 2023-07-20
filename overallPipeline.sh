echo "STARTING BUTYRATE!"

cd butyrate_rerun

nohup bash bowtieFullPipeline.sh > butyrateOutput.txt

cd ..

echo "END BUTYRATE!"

echo "****************************************************************"

echo "START PROPIONATE"

cd propionate_rerun

nohup bash bowtieFullPipeline.sh > propionateOutput.txt

cd ..

echo "END PROPIONATE. EVERYTHING IS COMPLETED"
echo "＼＼\\٩(˃̶͈̀௰˂̶͈́)و //／／"