cas;
caslib _all_ assign;

/* load images from nfs path */ 
proc cas;
	image.loadImages / 
		path="/mnt/viya-share/data/cifar-10-images"
		casout={caslib="casuser" name="cifar10train", replication=0, replace=true}
		recurse=true
		decode=true
		labelLevels=-1
		addColumns={"width", "height"}
	;
quit;


/* build CNN architecture */
proc cas;
   deepLearn.buildModel /
      modelTable={name="cifar_cnn", replace=true}
      type="CNN";
 
   deepLearn.addLayer /
      layer={type="input" nchannels=3 width=32 height=32}
      modelTable={name="cifar_cnn"}
      name="input";
 
   deepLearn.addLayer /
      layer={type="convolution" act="relu" width=3 height=3 stride=1 nFilters=32}
      modelTable={name="cifar_cnn"}
      name="conv1"
      srcLayers={"input"};
 
   deepLearn.addLayer /
      layer={type="convolution" act="relu" width=3 height=3 stride=1 nFilters=32}
      modelTable={name="cifar_cnn"}
      name="conv2"
      srcLayers={"conv1"};
 
   deepLearn.addLayer /
      layer={type="pooling" width=2 height=2 pool="max" stride=2 dropout=0.25}
      modelTable={name="cifar_cnn"}
      name="pool1"
      srcLayers={"conv2"};

   deepLearn.addLayer /
      layer={type="convolution" act="relu" width=3 height=3 stride=1 nFilters=64}
      modelTable={name="cifar_cnn"}
      name="conv3"
      srcLayers={"pool1"};

   deepLearn.addLayer /
      layer={type="convolution" act="relu" width=3 height=3 stride=1 nFilters=64}
      modelTable={name="cifar_cnn"}
      name="conv4"
      srcLayers={"conv3"};

   deepLearn.addLayer /
      layer={type="pooling" width=2 height=2 pool="max" stride=2 dropout=0.25}
      modelTable={name="cifar_cnn"}
      name="pool2"
      srcLayers={"conv4"};

   deepLearn.addLayer /
      layer={type="fc" n=512 act="relu" dropout=0.5}
      modelTable={name="cifar_cnn"}
      name="fc1"
      srcLayers={"pool2"};

   deepLearn.addLayer /
      layer={type="output" act="softmax" n=10}
      modelTable={name="cifar_cnn"}
      name="outlayer"
      srcLayers={"fc1"};
 
   deepLearn.modelInfo /
      modelTable={name="cifar_cnn"};
run;


/* train model */ 
proc cas;
	deepLearn.dltrain / 
		modelTable={caslib="casuser" name="cifar_cnn"}
		modelWeights={caslib="casuser" name="cifar_cnn_weight" replace=true}
		table={caslib="casuser" name="cifar10train"},
		/* validTable={"name":"cifar10valid"}, */
		inputs = "_image_", 
		target="_label_",
 		optimizer={
			algorithm={method='ADAM' learningRate=0.01}
			miniBatchSize=64
			maxEpochs=5
			logLevel=2
		}
/* 		gpu={device=0} */
	;
quit;