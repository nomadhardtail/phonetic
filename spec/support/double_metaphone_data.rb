# encoding: utf-8

module Phonetic
  DOUBLE_METAPHONE_TEST_TABLE = {
    'accede'       => ['AKST', 'AKST'],
    'accident'     => ['AKST', 'AKST'],
    'avvenente'    => ['AFNN', 'AFNN'],
    'Acker'        => ['AKR', 'AKR'],
    'Addams'       => ['ATMS', 'ATMS'],
    'Agnes'        => ['AKNS', 'ANS'],
    'Akkad'        => ['AKT', 'AKT'],
    'Alicia'       => ['ALS', 'ALX'],
    'Allasio'      => ['ALS', 'ALX'],
    'aqqa'         => ['AK', 'AK'],
    'arch'         => ['ARX', 'ARK'],
    'architect'    => ['ARKT', 'ARKT'],
    'Arnoff'       => ['ARNF', 'ARNF'],
    'Arnow'        => ['ARN', 'ARNF'],
    'Assia'        => ['AS', 'AS'],
    'artois'       => ['ART', 'ARTS'],
    'bacchus'      => ['PKS', 'PKS'],
    'bacci'        => ['PX', 'PX'],
    'bajador'      => ['PJTR', 'PHTR'],
    'Bajja'        => ['PJ', 'PJ'],
    'Barzizza'     => ['PRSS', 'PRST'],
    'bellocchio'   => ['PLX', 'PLX'],
    'bertucci'     => ['PRTX', 'PRTX'],
    'biaggi'       => ['PJ', 'PK'],
    'bioggi'       => ['PJ', 'PK'],
    'breaux'       => ['PR', 'PR'],
    'braço'        => ['PRS', 'PRS'],
    'cabrillo'     => ['KPRL', 'KPR'],
    'Cacgia'       => ['KK', 'KK'],
    'caesar'       => ['SSR', 'SSR'],
    'cagney'       => ['KKN', 'KKN'],
    'campbell'     => ['KMPL', 'KMPL'],
    'carlisle'     => ['KRLL', 'KRLL'],
    'carlysle'     => ['KRLL', 'KRLL'],
    'Chloride'     => ['KLRT', 'KLRT'],
    'changes'      => ['XNJS', 'XNKS'],
    'Character'    => ['KRKT', 'KRKT'],
    'Charisma'     => ['KRSM', 'KRSM'],
    'chemistry'    => ['KMST', 'KMST'],
    'cherry'       => ['XR', 'XR'],
    'chianti'      => ['KNT', 'KNT'],
    'chihor'       => ['XHR','XHR'],
    'chor'         => ['KR', 'KR'],
    'chore'        => ['XR', 'XR'],
    'chorus'       => ['KRS', 'KRS'],
    'Chymosin'     => ['KMSN', 'KMSN'],
    'Chynna'       => ['XN', 'XN'],
    'Cielo'        => ['SL', 'XL'],
    'Cioccolato'   => ['SKLT', 'XKLT'],
    'Columbus'     => ['KLMP', 'KLMP'],
    'cough'        => ['KF', 'KF'],
    'czerny'       => ['SRN', 'XRN'],
    'danger'       => ['TNJR', 'TNKR'],
    'dumb'         => ['TM', 'TM'],
    'edgar'        => ['ATKR', 'ATKR'],
    'edge'         => ['AJ', 'AJ'],
    'exam'         => ['AKSM', 'AKSM'],
    'exceed'       => ['AKST', 'AKST'],
    'filipowicz'   => ['FLPT', 'FLPF'],
    'focaccia'     => ['FKX', 'FKX'],
    'gallegos'     => ['KLKS', 'KKS'],
    'gear'         => ['JR', 'KR'],
    'Gebal'        => ['KPL', 'JPL'],
    'Gelatin'      => ['KLTN', 'JLTN'],
    'Gepard'       => ['KPRT', 'JPRT'],
    'Gerald'       => ['KRLT', 'JRLT'],
    'Gesture'      => ['KSTR', 'JSTR'],
    'geyser'       => ['KSR', 'JSR'],
    'geisha'       => ['KX', 'JX'],
    'ghiradelli'   => ['JRTL', 'JRTL'],
    'ghislane'     => ['JLN', 'JLN'],
    'ghost'        => ['KST', 'KST'],
    'gibbon'       => ['KPN', 'JPN'],
    'Gilbert'      => ['KLPR', 'JLPR'],
    'ginger'       => ['KNKR', 'JNJR'],
    'Giethoorn'    => ['K0RN', 'JTRN'],
    'Gneiss'       => ['NS', 'NS'],
    'gough'        => ['KF', 'KF'],
    'Grashof'      => ['KRXF', 'KRXF'],
    'gym'          => ['KM', 'JM'],
    'hochmeier'    => ['HKMR', 'HKMR'],
    'hugh'         => ['H', 'H'],
    'island'       => ['ALNT', 'ALNT'],
    'isle'         => ['AL', 'AL'],
    'Jankelowicz'  => ['JNKL', 'ANKL'],
    'Jacqueline'   => ['JKLN', 'AKLN'],
    'dejer'        => ['TJR', 'TJR'],
    'jose'         => ['HS', 'HS'],
    'Jose Villa'   => ['HSFL', 'HSF'],
    'joseph'       => ['JSF', 'HSF'],
    'Jugnot'       => ['JNT', 'AKNT'],
    'Katerine'     => ['KTRN', 'KTRN'],
    'Khia'         => ['K', 'K'],
    'Knight'       => ['NT', 'NT'],
    'laczo'        => ['LS', 'LX'],
    'laugh'        => ['LF', 'LF'],
    'Lawrence'     => ['LRNS', 'LRNS'],
    'Loretta'      => ['LRT', 'LRT'],
    'mac caffrey'  => ['MKFR', 'MKFR'],
    'mac gregor'   => ['MKRK', 'MKRK'],
    'macher'       => ['MKR', 'MKR'],
    'Maggie'       => ['MJ', 'MK'],
    'maña'         => ['MN', 'MN'],
    'McClellan'    => ['MKLL', 'MKLL'],
    'McHugh'       => ['MK', 'MK'],
    'McLaughlin'   => ['MKLF', 'MKLF'],
    'michael'      => ['MKL', 'MXL'],
    'Monaghan'     => ['MNKN','MNKN'],
    'Moosholzer'   => ['MSLS', 'MSLS'],
    'Mosheim'      => ['MSM', 'MSM'],
    'nation'       => ['NXN', 'NXN'],
    'numbers'      => ['NMRS', 'NMRS'],
    'orchestra'    => ['ARKS', 'ARKS'],
    'orchid'       => ['ARKT', 'ARKT'],
    'quest'        => ['KST', 'KST'],
    'Petrosian'    => ['PTRS', 'PTRX'],
    'pizza'        => ['PS', 'PTS'],
    'Pnina'        => ['NN', 'NN'],
    'Portia'       => ['PRX', 'PRX'],
    'Psionics'     => ['SNKS', 'XNKS'],
    'raspberry'    => ['RSPR', 'RSPR'],
    'ranger'       => ['RNJR', 'RNKR'],
    'resnais'      => ['RSN', 'RSNS'],
    'Rogge'        => ['RK', 'RK'],
    'rogier'       => ['RJ', 'RJR'],
    'rough'        => ['RF', 'RF'],
    'raj'          => ['RJ', 'R'],
    'san jacinto'  => ['SNHS', 'SNHS'],
    'Sevilla'      => ['SFL', 'SF'],
    'Scarlett'     => ['SKRL', 'SKRL'],
    'Schema'       => ['SKM', 'SKM'],
    'schenker'     => ['XNKR', 'SKNK'],
    'schermerhorn' => ['XRMR', 'SKRM'],
    'Schedule'     => ['SKTL', 'SKTL'],
    'schmidt'      => ['XMT', 'SMT'],
    'schneider'    => ['XNTR', 'SNTR'],
    'school'       => ['SKL', 'SKL'],
    'schooner'     => ['SKNR', 'SKNR'],
    'Schuylkill'   => ['SKLK', 'SKLK'],
    'Sciorra'      => ['SR', 'SR'],
    'Sholman'      => ['SLMN', 'SLMN'],
    'Shoeka'       => ['SK', 'SK'],
    'smith'        => ['SM0', 'XMT'],
    'snider'       => ['SNTR', 'XNTR'],
    'succeed'      => ['SKST', 'SKST'],
    'sugar'        => ['XKR', 'SKR'],
    'sugarless'    => ['XKRL', 'SKRL'],
    'szamos'       => ['SMS', 'XMS'],
    'tagliaro'     => ['TKLR', 'TLR'],
    'thames'       => ['TMS', 'TMS'],
    'thomas'       => ['TMS', 'TMS'],
    'Thorne'       => ['0RN', 'TRN'],
    'thumb'        => ['0M', 'TM'],
    'tichner'      => ['TXNR', 'TKNR'],
    'tough'        => ['TF', 'TF'],
    'Uomo'         => ['AM', 'AM'],
    'van gelder'   => ['FNKL', 'FNKL'],
    'Vasserman'    => ['FSRM', 'FSRM'],
    'von Neumann'  => ['FNNM', 'FNNM'],
    'wachtler'     => ['AKTL', 'FKTL'],
    'Wasserman'    => ['ASRM', 'FSRM'],
    'weschsler'    => ['AXSL', 'FXSL'],
    'Wesia'        => ['AS', 'FS'],
    'Womo'         => ['AM', 'FM'],
    'Winningham'   => ['ANNK', 'FNNK'],
    'whirlpool'    => ['ARLP', 'ARLP'],
    'wicz'         => ['ATS', 'FFX'],
    'wright'       => ['RT', 'RT'],
    'Xavier'       => ['SF', 'SFR'],
    'Yankelovich'  => ['ANKL', 'ANKL'],
    'zhao'         => ['J', 'J']
  }
end
