
if __name__ == '__main__':

  import os
  from sentenceanalysis.datasets import Dataset

  path = os.path.dirname(os.path.abspath(__file__))  # 현재 파일의 디렉토리
  dataset = Dataset( path + '/../_DATA/' )
  if dataset.load(path="words.txt", encoding="utf-8") :
    print( dataset.analyze_sentence( "가난한" ) )

