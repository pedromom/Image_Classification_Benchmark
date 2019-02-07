classdef Bench < Pipel & handle
    %BENCH Summary of this class goes here
    %   It' s the benchmark, a benchmark it's a pipe, the root pipe.
    
    %%
    properties(SetAccess = protected)
        imdsValidation=[];
        imdsTest=[];
        imdsTrain=[];
        curentPath='';
        benchVersion='V4.06';
    end
    
    properties(Access = private)
        rootPathDB='BenchDB\';
    end
    
    methods
        
        %%%%%%%%%%%%%
        % Construct %
        %%%%%%%%%%%%%
        
        function obj = Bench(name, dbase, data,prm)
            % Bench  Constructor. Do not call this constructor directly.
            %                       use BenchImage or BenchCNN
            
            %call subclass
            
            obj = obj@Pipel(name,'bench', [], prm);
            
            try
                obj.curentDB=strcat(obj.rootPathDB, fliplr(extractBefore(fliplr(data.path_),'\')));
            catch
                obj.curentDB=strcat(obj.rootPathDB, dbase,'\');
            end
            
            try
               % try
                    obj.imdsValidation=data.imdsValidation;
                    obj.imdsTrain=data.imdsTrain;
                    try
                        obj.imdsTest=data.imdsTest;
                    catch
                    end
                %catch
                %end
                
                % create folder
                tmps =strcat(obj.rootPathDB,dbase);
                
                if ~exist(tmps)
                    mkdir(tmps);
                    
                    
                    imdsTest= obj.imdsTest;
                    try
                        %save 'imdsTest' tmp;
                        save (strcat(tmps,'\','imdsTest'), 'imdsTest');
                    catch
                    end
                    
                    imdsTrain= obj.imdsTrain;
                    imdsValidation=obj.imdsValidation;
                    
                    % save 'imdsProcess' tmp tmp2;
                    save (strcat(tmps,'\','imdsProcess'),'imdsTrain','imdsValidation');
                    
                else
                    
                    warning('Bench, Imdb exist always !!! Loading the imds of the database : %s !!!', dbase );
                end
                
            catch
                
            end
            
            try %d
                
                addpath(strcat('.\Core',obj.benchVersion,'\Bench\Operation'));
                addpath(strcat('.\Core',obj.benchVersion,'\Bench\Interface'));
                
                
                %% try to load imds
                try % c
                    
                    load (strcat(obj.rootPathDB, dbase,'\imdsProcess.mat'));
                    obj.imdsValidation=imdsValidation;
                    obj.imdsTrain=imdsTrain;
                    
                    try %a
                        %formatting
                        try %aa
                            %with some of the base
                            obj.setImdsValidation(splitEachLabel(shuffle(obj.imdsValidation),obj.param.szDB));
                            obj.setImdsTrain(splitEachLabel(shuffle(obj.imdsTrain),obj.param.szDB));
                            obj.param = rmfield(obj.param,'szDB'); %remuve the field
                        catch %aa
                            %with all of the base
                            obj.setImdsValidation(shuffle(obj.imdsValidation));
                            obj.setImdsTrain(shuffle(obj.imdsTrain));
                        end %aa
                        
                    catch %a
                       % warning('Problem in Constructor Bench imdsValidation and/or Train not loaded.');
                    end %a
                    
                    %Loading imdsTest is optional in fonction of de bench type.
                    try %b
                        load (strcat(obj.rootPathDB, dbase,'\imdsTest.mat'));
                        obj.imdsTest=imdsTest;
                        
                        %formatting
                        try %ba
                            %with some of the base
                            obj.setImdsTest(splitEachLabel(obj.imdsTest,obj.param.szTDB));
                            obj.param = rmfield(obj.param,'szTDB'); %remuve the field
                        catch %ba
                            %with all of the base
                            obj.setImdsTest(obj.imdsTest);
                        end %ba
                        
                    catch %b
                    end %b
                    
                catch %c
                    %it not imds bench type.
                end %c
                
                %end
                
                %% path and URI (Uniform Resource Identifier) construction
                if ~isempty(data)
                    %if it not imds images bases
                    obj.setInterfaceIn(data);
                    try
                        obj.URI= char(strcat(obj.rootPathDB,dbase,obj.URI));
                    catch
                        obj.URI= char(strcat(obj.rootPathDB,dbase,obj.URI));
                    end
                    
                else
                    %if imds images bases
                    obj.URI=strcat(obj.rootPathDB,dbase,'\',char(obj.URI));
                end
                
                obj.URI=strrep(obj.URI,'.','_');
                obj.setCurentPath(obj.URI);
                
                %%
                obj.addCode(name,'MAIN',struct('name', 'MAIN'));
                obj.bnchTime=tic;
                
            catch %d
            end %d
            
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                         Methodes                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%
        %    Interface   %
        %%%%%%%%%%%%%%%%%%
        
        %%
        function obj = setInterface(obj,pipeName,kind,name)
            
            if obj.isExistPipe_(pipeName)
                
                lst=obj.getLstPipes();
                k=obj.getIdexPipe_(pipeName);
                
                lst=lst{k}.setInterface(kind,name);
                
            else
                throw(MException('Bench:setInterface','Name pipe not exist !!!'))
            end
            
            
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%
        % run Oprerations %
        %%%%%%%%%%%%%%%%%%%
        
        function output = run(obj)
            
            output=obj.runOp(obj.getLstOperations{1}.name);
            
            try
                if isstruct(output)
                    try
                        times=[];
                        
                        for op=obj.getLstOperations
                            times=[times, op{1}.times];
                        end
                        
                        output = setfield(output,'times',times);
                    catch
                    end
                end
            catch
            end
            
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%                       GET / SET                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%
        %   Bench   %
        %%%%%%%%%%%%%
        
        %         function output = getCurentTimeBench(obj)
        %             output = obj.times.crntTime;
        %         end
        
        %%
        %         function obj = setCurentTimeBench(obj, time)
        %             obj.times.crntTime=time;
        %         end
        
        %%
        function obj = setImdsValidation(obj, imds)
            obj.imdsValidation=imds;
        end
        
        %%
        function obj = setImdsTrain(obj, imds)
            obj.imdsTrain=imds;
        end
        
        %%
        function obj = setImdsTest(obj, imds)
            obj.imdsTest=imds;
        end
        
        %%
        function obj = setCurentPath(obj, path_)
            obj.curentPath=path_;
        end
        
        %%
        %%%%%%%%%%%%%%%%%%
        %      Param     %
        %%%%%%%%%%%%%%%%%%
        
        function output = getParam(obj, namePipe, nameOperation )
            pp=obj.getPipe(namePipe);
            op=pp{1}.getOperation(nameOperation);
            output=op.param;
        end
        
    end
end

