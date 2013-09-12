module Phonetic
  class RefinedSoundex
    CODE = {
      B: 1, P: 1,
      F: 2, V: 2,
      C: 3, K: 3, S: 3,
      G: 4, J: 4,
      Q: 5, X: 5, Z: 5,
      D: 6, T: 6,
      L: 7,
      M: 8, N: 8,
      R: 9
    }

    def self.code(word)
      w = word.upcase
      res = w[0]
      pg = nil
      w.chars.each do |c|
        g = CODE[c.to_sym] || 0
        if pg != g
          res += g.to_s
          pg = g
        end
      end
      res
    end
  end
end