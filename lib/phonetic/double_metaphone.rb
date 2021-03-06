# encoding: utf-8

require 'phonetic/algorithm'
require 'phonetic/double_metaphone/code'

module Phonetic
  # The Double Metaphone phonetic encoding algorithm is the second generation
  # of the Metaphone algorithm. Its original implementation was described
  # by Lawrence Philips in the June 2000 issue of C/C++ Users Journal.
  #
  # This implementation based on the PHP implementation by Stephen Woodbridge
  # and contains modifications of algorithm by Kevin Atkinson.
  # @see http://swoodbridge.com/DoubleMetaPhone/
  #      PHP implementation by Stephen Woodbridge
  # @see http://aspell.net/metaphone/dmetaph.cpp
  #      C++ implementation with modifications by Kevin Atkinson
  # @example
  #    Phonetic::DoubleMetaphone.encode('czerny') # => ['SRN', 'XRN']
  #    Phonetic::DoubleMetaphone.encode('dumb')   # => ['TM', 'TM']
  #    Phonetic::DoubleMetaphone.encode('edgar')  # => ['ATKR', 'ATKR']
  #    # or use alias:
  #    Phonetic::Metaphone2.encode('czerny') # => ['SRN', 'XRN']
  #    Phonetic::Metaphone2.encode('dumb')   # => ['TM', 'TM']
  #    Phonetic::Metaphone2.encode('edgar')  # => ['ATKR', 'ATKR']
  class DoubleMetaphone < Algorithm
    START_OF_WORD_MAP = {
      # skip these when at start of word
      /^([GKP]N|WR|PS)/ => ['', '', 1],
      # initial 'X' is pronounced 'Z' e.g. 'Xavier'
      /^X/ => ['S', 'S', 1],
      # all init vowels now map to 'A'
      /^[AEIOUY]/ => ['A', 'A', 1],
      # special case 'caesar'
      /^CAESAR/ => ['S', 'S', 1],
      # special case 'sugar-'
      /^SUGAR/ => ['X', 'S', 1],
      # -ges-, -gep-, -gel-, -gie- at beginning
      /^G(Y|E[SPBLYIR]|I[BLNE])/ => ['K', 'J', 2],
      # keep H if first & before vowel
      /^H[AEIOUY]/ => ['H', 'H', 2],
      # german & anglicisations, e.g. 'smith' match 'schmidt', 'snider' match 'schneider'
      /^S[MNLW]/ => ['S', 'X', 1],
      # ghislane, ghiradelli
      /^GHI/ => ['J', 'J', 2],
      /^GH/ => ['K', 'K', 2],
      # greek roots e.g. 'chemistry', 'chorus'
      /^CH(ARAC|ARIS|OR[^E]|YM|EM)/ => ['K', 'K', 2],
      # Wasserman should match Vasserman
      /^W[AEIOUY]/ => ['A', 'F', 0],
      # need Uomo to match Womo
      /^WH/ => ['A', 'A', 0]
    }

    # Encode word to its Double Metaphone code.
    def self.encode_word(word, options = { size: 4 })
      code_size = options[:size] || 4
      w = word.strip.upcase
      code = Code.new
      i = 0
      len = w.size
      last = len - 1
      # pad the original string so that we can index beyond the edge of the world
      w += ' ' * 5
      i += encode_start_of_word(w, code)
      while i < len && (code.first.size < code_size || code.last.size < code_size)
        case w[i]
        when 'A', 'E', 'I', 'O', 'U', 'Y'
          i += 1
        when 'B'
          # "-mb", e.g", "dumb", already skipped over...
          i += gen_encode(w, i, 'P', 'P', code)
        when 'Ç', 'ç'
          code.add 'S', 'S'
          i += 1
        when 'C', 'D'
          i += char_encode(w, i, len, code)
        when 'F', 'K', 'N'
          i += gen_encode(w, i, w[i], w[i], code)
        when 'G', 'H', 'J', 'L', 'M'
          i += char_encode(w, i, len, code)
        when 'Ñ', 'ñ'
          code.add 'N', 'N'
          i += 1
        when 'P'
          i += encode_p(w, i, len, code)
        when 'Q'
          i += gen_encode(w, i, 'K', 'K', code)
        when 'R', 'S', 'T'
          i += char_encode(w, i, len, code)
        when 'V'
          i += gen_encode(w, i, 'F', 'F', code)
        when 'W', 'X', 'Z'
          i += char_encode(w, i, len, code)
        else
          i += 1
        end
      end
      code.results(code_size)
    end

    def self.encode(str, options = { size: 4 })
      encode_word(str, options)
    end

    private

    def self.encode_start_of_word(w, code)
      i = 0
      START_OF_WORD_MAP.each do |r, v|
        if w =~ r
          code.add v[0], v[1]
          i = v[2]
          break
        end
      end
      i
    end

    def self.gen_encode(w, i, primary, secondary, code)
      code.add primary, secondary
      w[i + 1] == w[i] ? 2 : 1
    end

    def self.char_encode(w, i, len, code)
      self.send "encode_#{w[i].downcase}", w, i, len, code
    end

    def self.encode_c(w, i, len, code)
      r = 1
      case
      # various germanic
      when c_germanic?(w, i)
        code.add 'K', 'K'
        r += 1
      when w[i, 2] == 'CH'
        r += encode_ch(w, i, len, code)
      when w[i, 2] == 'CZ' && !(i > 1 && w[i - 2, 4] == 'WICZ')
        # e.g, 'czerny'
        code.add 'S', 'X'
        r += 1
      when w[i + 1, 3] == 'CIA'
        # e.g., 'focaccia'
        code.add 'X', 'X'
        r += 2
      # double 'C', but not if e.g. 'McClellan'
      when w[i, 2] == 'CC' && !(i == 1 && w[0] == 'M')
        r += encode_cc(w, i, code) + 1
      when w[i, 2] =~ /C[KGQ]/
        code.add 'K', 'K'
        r += 1
      # italian vs. english
      when w[i, 3] =~ /CI[OEA]/
        code.add 'S', 'X'
        r += 1
      when w[i, 2] =~ /C[IEY]/
        code.add 'S', 'S'
        r += 1
      else
        code.add 'K', 'K'
        # name sent in 'mac caffrey', 'mac gregor'
        if w[i + 1, 2] =~ /\s[CQG]/
          r += 2
        elsif w[i + 1] =~ /[CKQ]/ && w[i + 1, 2] !~ /C[EI]/
          r += 1
        end
      end
      r
    end

    def self.encode_d(w, i, len, code)
      r = 1
      case
      when w[i + 1, 2] =~ /G[IEY]/
        # e.g. 'edge'
        code.add 'J', 'J'
        r += 2
      when w[i + 1] == 'G'
        # e.g. 'edgar'
        code.add 'TK', 'TK'
        r += 1
      when w[i + 1] =~ /[TD]/
        code.add 'T', 'T'
        r += 1
      else
        code.add 'T', 'T'
      end
      r
    end

    def self.encode_g(w, i, len, code)
      r = 2
      case
      when w[i + 1] == 'H'
        encode_gh(w, i, code)
      when w[i + 1] == 'N'
        encode_gn(w, i, code)
      # 'tagliaro'
      when w[i + 1, 2] == 'LI' && !slavo_germanic?(w)
        code.add 'KL', 'L'
      # -ger-,  -gy-
      when g_ger_or_gy?(w, i)
        code.add 'K', 'J'
      when g_italian?(w, i)
        if w[0, 4] =~ /^(V[AO]N\s|SCH)/ || w[i + 1, 2] == 'ET'
          code.add 'K', 'K'
        elsif w[i + 1, 4] =~ /IER\s/
          code.add 'J', 'J'
        else
          code.add 'J', 'K'
        end
      else
        r -= 1 if w[i + 1] != 'G'
        code.add 'K', 'K'
      end
      r
    end

    def self.encode_h(w, i, len, code)
      r = 1
      # keep if btw. 2 vowels
      if i > 0 && vowel?(w[i - 1]) && vowel?(w[i + 1])
        code.add 'H', 'H'
        r += 1
      end
      r
    end

    def self.encode_j(w, i, len, code)
      r = 1
      last = len - 1
      # obvious spanish, 'jose', 'san jacinto'
      if w[i, 4] == 'JOSE' || w[0, 4] =~ /SAN\s/
        if i == 0 && w[i + 4] == ' ' || w[0, 4] =~ /SAN\s/
          code.add 'H', 'H'
        else
          code.add 'J', 'H'
        end
      else
        if i == 0 && w[i, 4] != 'JOSE'
          code.add 'J', 'A'
          # Yankelovich/Jankelowicz
        else
          # spanish pron. of e.g. 'bajador'
          if j_spanish_pron?(w, i)
            code.add 'J', 'H'
          elsif i == last
            code.add 'J', ''
          elsif w[i + 1] !~ /[LTKSNMBZ]/ && !(i > 0 && w[i - 1] =~ /[SKL]/)
            code.add 'J', 'J'
          end
        end
        r += 1 if w[i + 1] == 'J'
      end
      r
    end

    def self.encode_l(w, i, len, code)
      r = 1
      if w[i + 1] == 'L'
        # spanish e.g. 'cabrillo', 'gallegos'
        if ll_spanish?(w, i, len)
          code.add 'L', ''
        else
          code.add 'L', 'L'
        end
        r += 1
      else
        code.add 'L', 'L'
      end
      r
    end

    def self.encode_m(w, i, len, code)
      r = 1
      # 'dumb','thumb'
      r += 1 if i > 0 && w[i - 1, 5] =~ /UMB(  |ER)/ || w[i + 1] == 'M'
      code.add 'M', 'M'
      r
    end

    def self.encode_p(w, i, len, code)
      r = 1
      if w[i + 1] == 'H'
        code.add 'F', 'F'
        r += 1
      else
        # also account for "campbell", "raspberry"
        r += 1 if w[i + 1] =~ /[PB]/
        code.add 'P', 'P'
      end
      r
    end

    def self.encode_r(w, i, len, code)
      last = len - 1
      # french e.g. 'rogier', but exclude 'hochmeier'
      if r_french?(w, i, last)
        code.add '', 'R'
      else
        code.add 'R', 'R'
      end
      w[i + 1] == 'R' ? 2 : 1
    end

    def self.encode_s(w, i, len, code)
      r = 1
      last = len - 1
      case
      # special cases 'island', 'isle', 'carlisle', 'carlysle'
      when i > 0 && w[i - 1, 3] =~ /[IY]SL/
      when w[i, 2] == 'SH'
        r += encode_sh(w, i, code)
      # italian & armenian
      when w[i, 3] =~ /SI[OA]/
        if !slavo_germanic?(w)
          code.add 'S', 'X'
        else
          code.add 'S', 'S'
        end
        r += 2
      # -sz- in slavic language altho in hungarian it is pronounced 's'
      when w[i, 2] == 'SZ'
        code.add 'S', 'X'
        r += 1
      when w[i, 2] == 'SC'
        r += encode_sc(w, i, code)
      else
        if s_french?(w, i, last)
          code.add '', 'S'
        else
          code.add 'S', 'S'
        end
        r += 1 if w[i + 1] =~ /[SZ]/
      end
      r
    end

    def self.encode_t(w, i, len, code)
      r = 1
      if w[i, 4] =~ /^(TION|TIA|TCH)/
        code.add 'X', 'X'
        r += 2
      elsif w[i, 2] == 'TH' || w[i, 3] == 'TTH'
        # special case 'thomas', 'thames' or germanic
        if w[i + 2, 2] =~ /[OA]M/ || w[0, 4] =~ /^(VAN |VON |SCH)/
          code.add 'T', 'T'
        else
          code.add '0', 'T'
        end
        r += 1
      else
        r += 1 if w[i + 1] =~ /[TD]/
        code.add 'T', 'T'
      end
      r
    end

    def self.encode_w(w, i, len, code)
      last = len - 1
      r = 1
      # can also be in middle of word
      if w[i, 2] == 'WR'
        code.add 'R', 'R'
        r += 1
      else
        # Arnow should match Arnoff
        if i == last && i > 0 && vowel?(w[i - 1]) ||
           i > 0 && w[i - 1, 5] =~ /[EO]WSK[IY]/ ||
           w[0, 3] == 'SCH'
          code.add '', 'F'
        elsif w[i, 4] =~ /WICZ|WITZ/
          # polish e.g. 'filipowicz'
          code.add 'TS', 'FX'
          r += 3
        end
      end
      r
    end

    def self.encode_x(w, i, len, code)
      # french e.g. breaux
      code.add 'KS', 'KS' unless x_french?(w, i, len - 1)
      w[i + 1] =~ /[CX]/ ? 2 : 1
    end

    def self.encode_z(w, i, len, code)
      r = 1
      # chinese pinyin e.g. 'zhao'
      if w[i + 1] == 'H'
        code.add 'J', 'J'
        r += 1
      else
        if w[i + 1, 2] =~ /Z[OIA]/ ||
           slavo_germanic?(w) && i > 0 && w[i - 1] != 'T'
          code.add 'S', 'TS';
        else
          code.add 'S', 'S';
        end
        r += 1 if w[i + 1] == 'Z'
      end
      r
    end

    def self.encode_ch(w, i, len, code)
      case
      # italian 'chianti'
      when w[i, 4] == 'CHIA'
        code.add 'K', 'K'
      # find 'michael'
      when i > 0 && w[i, 4] == 'CHAE'
        code.add 'K', 'X'
      # germanic, greek, or otherwise 'ch' for 'kh' sound
      when ch_germanic_or_greek?(w, i, len)
        code.add 'K', 'K'
      when i == 0
        code.add 'X', 'X'
      when w[0, 2] == 'MC'
        # e.g., "McHugh"
        code.add 'K', 'K'
      else
        code.add 'X', 'K'
      end
      1
    end

    def self.encode_cc(w, i, code)
      r = 0
      # 'bellocchio' but not 'bacchus'
      if w[i + 2, 1] =~ /[IEH]/ && w[i + 2, 2] != 'HU'
        # 'accident', 'accede' 'succeed'
        if i == 1 && w[i - 1] == 'A' || w[i - 1, 5] =~ /UCCEE|UCCES/
          # 'bacci', 'bertucci', other italian
          code.add 'KS', 'KS'
        else
          code.add 'X', 'X'
        end
        r = 1
      else
        # Pierce's rule
        code.add 'K', 'K'
      end
      r
    end

    def self.encode_gh(w, i, code)
      if i > 0 && !vowel?(w[i - 1])
        code.add 'K', 'K'
      # Parker's rule (with some further refinements)
      elsif !(i > 1 && w[i - 2] =~ /[BHD]/ || # e.g., 'hugh'
              i > 2 && w[i - 3] =~ /[BHD]/ || # e.g., 'bough'
              i > 3 && w[i - 4] =~ /[BH]/)    # e.g., 'broughton'
        # e.g., 'laugh', 'McLaughlin', 'cough', 'gough', 'rough', 'tough'
        if i > 2 && w[i - 3, 3] =~ /[CGLRT].U/
          code.add 'F', 'F'
        elsif i > 0 && w[i - 1] != 'I'
          code.add 'K', 'K'
        end
      end
    end

    def self.encode_gn(w, i, code)
      if i == 1 && vowel?(w[0]) && !slavo_germanic?(w)
        code.add 'KN', 'N'
      # not e.g. 'cagney'
      elsif w[i + 2, 2] != 'EY' && w[i + 1] != 'Y' && !slavo_germanic?(w)
        code.add 'N', 'KN'
      else
        code.add 'KN', 'KN'
      end
    end

    def self.encode_sh(w, i, code)
      # germanic
      if w[i + 1, 4] =~ /H(EIM|OEK|OL[MZ])/
        code.add 'S', 'S'
      else
        code.add 'X', 'X'
      end
      1
    end

    def self.encode_sc(w, i, code)
      # Schlesinger's rule
      if w[i + 2] == 'H'
        # dutch origin, e.g. 'school', 'schooner'
        if w[i + 3, 2] =~ /OO|UY|E[DM]/
          code.add 'SK', 'SK'
        # 'schermerhorn', 'schenker'
        elsif w[i + 3, 2] =~ /E[RN]/
          code.add 'X', 'SK'
        elsif i == 0 && !vowel?(w[3]) && w[3] != 'W'
          code.add 'X', 'S'
        else
          code.add 'X', 'X'
        end
      elsif w[i + 2] =~ /[IEY]/
        code.add 'S', 'S'
      else
        code.add 'SK', 'SK'
      end
      2
    end

    def self.slavo_germanic?(w)
      w =~ /W|K|CZ|WITZ/
    end

    def self.vowel?(c)
      c =~ /[AEIOUY]/
    end

    def self.c_germanic?(w, i)
      # various germanic
      i > 1 && w[i - 2, 6] =~ /(^[^AEIOUY]ACH[^IE])|([BM]ACHER)/
    end

    def self.ch_germanic_or_greek?(w, i, len)
      # germanic, greek, or otherwise 'ch' for 'kh' sound
      w[0, 4] =~ /^(V[AO]N\s|SCH)/ ||
      # 'architect but not 'arch', 'orchestra', 'orchid'
      i > 1 && w[i - 2, 6] =~ /ORCHES|ARCHIT|ORCHID/ ||
      (w[i + 2] =~ /[TS]/) ||
      (i > 0 && w[i - 1] =~ /[AOUE]/ || i == 0) &&
      # e.g., 'wachtler', 'wechsler', but not 'tichner'
      (w[i + 2] =~ /[LRNMBHFVW ]/ || i + 2 >= len)
    end

    def self.g_ger_or_gy?(w, i)
      # -ger-,  -gy-
      w[i + 1, 2] =~ /^(ER|Y)/ &&
      w[0, 6] !~ /[DRM]ANGER/ &&
      !(i > 0 && w[i - 1] =~ /[EI]/) &&
      !(i > 0 && w[i - 1, 3] =~ /[RO]GY/)
    end

    def self.g_italian?(w, i)
      # italian e.g, 'biaggi'
      w[i + 1] =~ /[EIY]/ || (i > 0 && w[i - 1, 4] =~ /[AO]GGI/)
    end

    def self.j_spanish_pron?(w, i)
      # spanish pron. of e.g. 'bajador'
      i > 0 && vowel?(w[i - 1]) && !slavo_germanic?(w) && w[i + 1] =~ /[AO]/
    end

    def self.ll_spanish?(w, i, len)
      last = len - 1
      # spanish e.g. 'cabrillo', 'gallegos'
      (i == len - 3 && i > 0 && w[i - 1, 4] =~ /ILL[OA]|ALLE/) ||
      (last > 0 && w[last - 1, 2] =~ /[AO]S/ || w[last] =~ /[AO]/) &&
      (i > 0 && w[i - 1, 4] == 'ALLE')
    end

    def self.r_french?(w, i, last)
      # french e.g. 'rogier', but exclude 'hochmeier'
      i == last && !slavo_germanic?(w) &&
      i > 1 && w[i - 2, 2] == 'IE' &&
      !(i > 3 && w[i - 4, 2] =~ /M[EA]/)
    end

    def self.s_french?(w, i, last)
      # french e.g. 'resnais', 'artois'
      i == last && i > 1 && w[i - 2, 2] =~ /[AO]I/
    end

    def self.x_french?(w, i, last)
      # french e.g. breaux
      i == last && (i > 2 && w[i - 3, 3] =~ /[IE]AU/ || i > 1 && w[i - 2, 2] =~ /[AO]U/)
    end
  end
end
