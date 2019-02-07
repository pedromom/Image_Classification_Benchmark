classdef BenchCNN < Bench & handle
    
    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = BenchCNN(name, dbase, data,prm)
            % BenchCNN  Constructor.
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
            
            obj = obj@Bench(name,dbase, data{1}, prm);
            
            try
                obj.setInterfaceIn(data);
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

