classdef InterfaceImdsForCNN < Interface_DB
    
    %%
    properties (SetAccess = protected)
        net;
        
    end
    
    %%
    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = InterfaceImdsForCNN(name,net,path_, prcTrain, prcValidation)
            % InterfaceImdsForCNN  Constructor.
            %   name = name of CNN treatment.
            %   net = name of CNN net.
            %           exemples :
            %                InterfaceImdsForCNN('CNN12','alexnet')
            
               
            pth=[];
            prcT=[];
            prcV=[];
            if exist('path_')
                pth=path_;
                prcT=prcTrain;
                prcV=prcValidation;
            end
            
            obj = obj@Interface_DB(pth,prcT, prcV);
            
            try
                
                obj=obj.setName(name);
                obj=obj.setKind('CNNInterface');
                obj.net=net;
                obj.URI=net;
                         
            catch
            end
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                         Methodes                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%
        function output = addAtURI(obj)
  
            output=strcat('\',obj.URI);
            
        end
        
         %%
        function obj = formatIn(obj)
          

           obj.imdsTrain=obj.owner.findBench.imdsTrain;
           obj.imdsValidation=obj.owner.findBench.imdsValidation;
           obj.imdsTest=obj.owner.findBench.imdsTest;
           obj.path_=obj.owner.findBench.interfaceIn{1}.path_;
        end
        
        %%
        function output = runCNN(obj,MiniBatchSize,MaxEpochs,ValidationFrequency,pp)
            
            bnch=pp.findBench;
            
            [augimdsTrain,augimdsValidation,lgraph]=obj.initNet_(bnch);
            
            options = trainingOptions('sgdm', ...
                'MiniBatchSize',MiniBatchSize, ...
                'MaxEpochs',MaxEpochs, ...
                'InitialLearnRate',1e-4, ...
                'ValidationData',augimdsValidation, ...
                'ValidationFrequency',ValidationFrequency, ...
                'ValidationPatience',Inf, ...
                'Verbose',false ,...
                'Plots','training-progress');
            
            net = trainNetwork(augimdsTrain,lgraph,options);
            
            output = struct('name',obj.name,'CNN',obj.net,'net',net, 'kind', obj.kind);
        end

        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function output = getFileName(obj)
            output = obj.owner.algo;
        end
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%                   PRIVATE FUNCTIONS                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    methods ( Access = protected)
        %%
        function output = init_googlenet_(obj, lgraph,bnch)
            
            lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});
            
            numClasses = numel(categories(bnch.imdsTrain.Labels));  %Nombre de classes pour la premiere couche afin de l'adapter au reste du CNN
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            
            lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc');
            
            layers = lgraph.Layers;
            connections = lgraph.Connections;
            
            layers(1:110) = freezeWeights(layers(1:110));
            lgraph = createLgraphUsingConnections(layers,connections);
            
            output=lgraph;
            
        end
        
        %%
        function output = init_resnet101_(obj, lgraph,bnch)
            
            lgraph = removeLayers(lgraph,{ 'fc1000', 'prob','ClassificationLayer_predictions'});
            
            numClasses = numel(categories(bnch.imdsTrain.Labels));  %Nombre de classes pour la premiere couche afin de l'adapter au reste du CNN
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            
            lgraph = connectLayers(lgraph,'pool5','fc');
            
            layers = lgraph.Layers;
            connections = lgraph.Connections;
            
            layers(1:110) = freezeWeights(layers(1:110));
            lgraph = createLgraphUsingConnections(layers,connections);
            
            output=lgraph;
            
        end
        
        %%
        function output = init_resnet50_(obj, lgraph,bnch)
            
            lgraph = removeLayers(lgraph,{ 'ClassificationLayer_fc1000', 'fc1000_softmax', 'fc1000'});
            
            numClasses = numel(categories(bnch.imdsTrain.Labels));  %Nombre de classes pour la premiere couche afin de l'adapter au reste du CNN
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            
            lgraph = connectLayers(lgraph,'avg_pool','fc');
            
            layers = lgraph.Layers;
            connections = lgraph.Connections;
            
            layers(1:110) = freezeWeights(layers(1:110));
            lgraph = createLgraphUsingConnections(layers,connections);
            
            output=lgraph;
            
        end
        
        %%
        function output = init_inceptionv3_(obj, lgraph,bnch)
            
            lgraph = removeLayers(lgraph,{'predictions', 'predictions_softmax','ClassificationLayer_predictions'});
            
            numClasses = numel(categories(bnch.imdsTrain.Labels));  %Nombre de classes pour la premiere couche afin de l'adapter au reste du CNN
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            
            lgraph = connectLayers(lgraph,'avg_pool','fc');
            
            layers = lgraph.Layers;
            connections = lgraph.Connections;
            
            layers(1:110) = freezeWeights(layers(1:110));
            lgraph = createLgraphUsingConnections(layers,connections);
            
            output=lgraph;
            
        end
        
        %%
        function output = init_vgg16_(obj, lgraph,bnch)
            
            lgraph = removeLayers(lgraph,{'output', 'prob','fc8'});
            
            numClasses = numel(categories(bnch.imdsTrain.Labels));  %Nombre de classes pour la premiere couche afin de l'adapter au reste du CNN
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            
            lgraph = connectLayers(lgraph,'drop7','fc');
            
            layers = lgraph.Layers;
            connections = lgraph.Connections;
            
            layers(1:end) = freezeWeights(layers(1:end));
            lgraph = createLgraphUsingConnections(layers,connections);
            
            output=lgraph;
            
        end
        
        %%
        function output = init_vgg19_(obj, lgraph,bnch)
            
            lgraph = removeLayers(lgraph,{'output', 'prob','fc8'});
            
            numClasses = numel(categories(bnch.imdsTrain.Labels));  %Nombre de classes pour la premiere couche afin de l'adapter au reste du CNN
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            
            lgraph = connectLayers(lgraph,'drop7','fc');
            
            layers = lgraph.Layers;
            connections = lgraph.Connections;
            
            layers(1:end) = freezeWeights(layers(1:end));
            lgraph = createLgraphUsingConnections(layers,connections);
            
            output=lgraph;
            
        end
        
        %%
        function output = init_alexnet_(obj, lgraph,bnch)
            
            lgraph = removeLayers(lgraph,{'output', 'prob','fc8'});
            
            numClasses = numel(categories(bnch.imdsTrain.Labels));  %Nombre de classes pour la premiere couche afin de l'adapter au reste du CNN
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            
            lgraph = connectLayers(lgraph,'drop7','fc');
            
            layers = lgraph.Layers;
            connections = lgraph.Connections;
            
            layers(1:end) = freezeWeights(layers(1:end));
            lgraph = createLgraphUsingConnections(layers,connections);
            
            output=lgraph;
            
        end
        
        %%
        function [augimdsTrain,augimdsValidation,lgraph] = initNet_(obj,bnch)
            
            try

                net = eval(obj.net);
                
                try
                    lgraph = layerGraph(net);
                catch
                    lgraph=layerGraph(net.Layers);
                end
                
                inputSize = net.Layers(1).InputSize;
                
                lgraph=eval(strcat('obj.init_',obj.net,'_(lgraph,bnch)'));
                
                %Normalisation des images
                pixelRange = [-30 30];
                imageAugmenter = imageDataAugmenter( ...
                    'RandXReflection',true, ...
                    'RandXTranslation',pixelRange, ...
                    'RandYTranslation',pixelRange);
                
                augimdsTrain = augmentedImageDatastore(inputSize(1:2),bnch.imdsTrain, ...
                    'DataAugmentation',imageAugmenter);
                
                augimdsValidation = augmentedImageDatastore(inputSize(1:2),bnch.imdsValidation);
                
            catch
            end  
        end
    end
    
end

