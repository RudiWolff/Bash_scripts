#!/bin/bash
# exemple menu amb select i break v2
mis="Tria opcio (qualsevol d'incorrecta acaba):"
echo $mis
select opcio in "ls" "ps" "date"; do
	if [ "$opcio" != "" ]; then
		echo "Has triat $opcio. Vaig a executar-lo:"
		$opcio
		echo $mis
	else
		break
	fi
done
echo "Final"

