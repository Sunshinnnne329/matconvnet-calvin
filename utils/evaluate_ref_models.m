function evaluate_ref_models()
% Evaluate MatConvNet reference models to validate them

addpath(fullfile(fileparts(mfilename('fullpath'))), '..','examples');

models = {...
  'caffe-ref', ...
  'caffe-alex', ...
  'vgg-s', ...
  'vgg-m', ...
  'vgg-f'} ;

for i = 1:numel(models)
  opts.dataDir = 'data/imagenet12' ;
  opts.expDir = sprintf('data/models-eval/%s', models{i}) ;
  opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
  opts.modelPath = sprintf('data/models/imagenet-%s.mat', models{i}) ;
  opts.lite = false ;
  opts.numFetchThreads = 12 ;
  opts.train.batchSize = 256 ;
  opts.train.numEpochs = 1 ;
  opts.train.useGpu = true ;
  opts.train.prefetch = true ;
  opts.train.expDir = opts.expDir ;

  resultPath = fullfile(opts.expDir, 'results.mat') ;
  if ~exist(resultPath)
    results = cnn_imagenet_evaluate(opts) ;
    save(fullfile(opts.expDir, 'results.mat'), 'results') ;
  end
end

for i = 1:numel(models)
  opts.expDir = sprintf('data/models-eval/%s', models{i}) ;
  resultPath = fullfile(opts.expDir, 'results.mat') ;
  load(resultPath, 'results') ;

  fprintf('%15s: err %5.2f, top5 %5.2f\n', models{i}, ...
          results.val.error(end)*100, ...
          results.val.topFiveError(end)*100);
end