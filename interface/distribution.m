function [imdsTrain,imdsValidation,imdsTest] = distribution(path_, pctValidation, prcTrain)

try
    imds = imageDatastore(path_, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');
    
    try
        if (pctValidation + prcTrain)>1
            warning('Error distribution : factor of proportion validation+Train > 1 !!!')
            prcTrain=0.7;
            pctValidation=0.3;
        end
    catch
        warning('Error distribution : Pas de variables pctValidation ou prcTrain !!!')
        prcTrain=0.7;
        pctValidation=0.3;
    end
    
    pctTest=1-(pctValidation+prcTrain);
    
    try
        [imdsTest,imdsProcess] = splitEachLabel(imds,pctTest,'randomized');
        prcTrain=(length(imdsProcess.Labels)-(length(imdsTest.Labels)*(pctValidation/pctTest)))/length(imdsProcess.Labels);
    catch
        imdsProcess=imds;
    end
    
    [imdsTrain,imdsValidation] = splitEachLabel(imdsProcess,prcTrain,'randomized');
    %save 'imdsTest' imdsTest;
    %save 'imdsProcess' imdsTrain imdsValidation;
    
    imdsTrain=shuffle(imdsTrain);
    imdsValidation=shuffle(imdsValidation);
    
catch
    warning('Error distribution : Bad path !!!')
end

end