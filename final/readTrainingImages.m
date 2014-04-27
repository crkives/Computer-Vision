function images=readTrainingImages(path, fileExt)
    fname = dir([path, strcat('*',fileExt)]); 
    fnum = length(fname);
    images = cell(fnum,1);
    for i=1:fnum
       images{i} = imread([path,fname(i).name]);
    end
end