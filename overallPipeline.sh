echo "STARTING BUTYRATE!"

nohup bash butyrate_rerun/bowtieFullPipeline.sh > butyrateOutput.txt

echo "END BUTYRATE!"

echo "****************************************************************"

echo "START PROPIONATE"

nohup bash propionate_rerun/bowtieFullPipeline.sh > propionateOutput.txt

echo "END PROPIONATE. EVERYTHING IS COMPLETED"
echo "＼＼\\٩(˃̶͈̀௰˂̶͈́)و //／／"