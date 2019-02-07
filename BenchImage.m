classdef BenchImage < Bench & handle

    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = BenchImage(name,dbase, data, prm)
            % BenchImage  Constructor.
            %   name = name of benchmark and name name of the file that contains the main.
            %   dbase = name of data base.
            %   data = list or colection of interfaces.
            %           the interfaces can be InterfaceImage,
            %           InterfaceImdsForCNNWithTest or InterfaceImdsForCNN
            %           exemples :
            %               [InterfaceImdsForCNNWithTest('CNN1','alexnet'),...
            %               InterfaceImdsForCNNWithTest('CNN7','vgg16')]
            %               or
            %               {InterfaceImdsForCNNWithTest('CNN1','alexnet'),...
            %               InterfaceImdsForCNN('CNN7','vgg16')}
            %               or
            %               [InterfaceImage('mon_image3','3.jpg'),...
            %               InterfaceImage('mon_image4','800.jpg')]
            %   prm = structure containing the parameters.
            %           exemple :
            %               struct('szDB',0.1,...
            %                      'MiniBatchSize',10, ...
            %                      'MaxEpochs',1, ...
            %                      'ValidationFrequency',3));
            
      
            
            if ~exist('prm')
                prm={};
            end
            
            if isempty(data)
                data=dbase;
            end
            
            obj = obj@Bench(name,dbase, data, prm);
                  
            try
 
                try
                    
                    lstIntValidation=[];
                    for intValidation=obj.imdsValidation.Files'
                        lstIntValidation=[lstIntValidation, InterfaceObject(char(intValidation),intValidation)];
                    end
                    
                    lstIntTrain=[];
                    for intTrain=obj.imdsTrain.Files'
                        lstIntTrain=[lstIntTrain, InterfaceObject(char(intTrain),intTrain)];
                    end
                    
                    lstIntTest=[];
                    for intTest=obj.imdsTest.Files'
                        lstIntTest=[lstIntTest, InterfaceObject(char(intTest),intTest)];
                    end
                    
                    obj.setInterfaceIn([ InterfaceImds('validation',lstIntValidation),...
                        InterfaceImds('train',lstIntTrain),...
                        InterfaceImds('test',lstIntTest)]);
                    
                    
                catch
                    obj.setInterfaceIn(data);
                end
                
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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
end

