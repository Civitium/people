module People
  # Class to parse names into their components like first, middle, last, etc.
  class NameParser

    # Internal: Regex for matching name prefixes such as honorifics
    TITLES = %r!
      ^(
        خانم                                                # Persian Mrs ?
        | (?:Lt|Leut|Lieut)\.?
        | Air\sCommander
        | Air\sCommodore
        | Air\sMarshall
        | Ald(?:\.|erman)?
        | Baron(?:ess)?
        | Bishop
        | Brig(?:adier)?
        | Brother
        | Capt(?:\.|ain)?
        | Cdr\.?
        | Chaplain
        | Colonel
        | Commander
        | Commodore
        | Count(?:ess)?
        | Dame
        | Det\.?
        | Dhr\.?
        | Doctor
        | Dr\.?
        | Father
        | Field\sMarshall
        | Flt?\.?(?:\s(?:Lt|Off)\.?)                       # Fl Lt, Flt Lt, Fl Off, Flt Off
        | Flight(?:\s(?:Lieutenant|Officer))               # Flight Lieutenant, Flight Officer
        | Frau
        | Fr\.?
        | Gen(?:\.|eral)?
        | Herr
        | Hr\.?
        | Hon\.?(?>ourable)?
        | Insp\.?
        | Judge
        | Justice
        | Khaanom                                         # Persian Mrs
        | Lady
        | Lieutenant(?:\s(?:Commander|Colonel|General))?  # Lieutenant, Lieutenant Commander, Lieutenant Colonel, Lieutenant General
        | Lord
        | Lt\.?(?:\s(?:Cdr|Col|Gen)\.?)?                  # Lt, Lt Col, Lt Cdr, Lt Gen
        | M/s\.?
        | Madam(?:e)?
        | Maid
        | Maj\.?(?:\sGen\.?)?                             # Maj, Maj Gen
        | Major(?:\sGeneral)?                             # Major, Major General
        | Mast(?:\.|er)?
        | Matron
        | Messrs
        | Miss\.?
        | Mister
        | Mme\.?
        | Most\sRever[e|a]nd
        | Mother(?:\sSuperior)?                           # Mother, Mother Superior
        | Mr\.?\sand\sMrs\.?
        | Mrs?\.?
        | Ms?gr\.?
        | Ms\.?
        | Mt\.?\sRevd\.?
        | Mx\.?
        | Pastor
        | Private
        | Prof(?:\.|essor)?                               # Proffessor, Prof
        | Pte\.
        | Rabbi
        | Revd?\.?
        | Rever[e|a]nd
        | Sargent
        | Senhor
        | Senhora
        | Senhorita
        | Sgt\.?
        | Sig.(?:a|ra)?
        | Signor(?:a|e)
        | Sir
        | Sister
        | Sr(?:a|ta)?\.?
        | V\.?\ Revd?\.?
        | Very\ Rever[e|a]nd
      )
    !xo
    
    # Internal: Regex to match suffixes or honorifics after names
    SUFFIXES  = %r!
      (
        APC
        | Attorney[\s\-]at[\s\-]Law\.?       # Attorney at Law, Attorney-at-Law
        | BS
        | C\.?P\.?A\.?
        | CHB
        | D\.?[DMOPV]\.?[SM]?\.?             # DMD, DO, DPM, DDM, DVM
        | DSC
        | Esq(?>\.|uire\.?)?                 # Esq, Esquire
        | FAC(?>P|S)                         # FACP, FACS
        | \b(?:X{0,3}I{0,3}(?:X|V)?I{0,3})[IXV]{1,}\.?\Z   # roman numbers I - XXXXVIII, if they're written proper
        | I{1,3},?\sEsq\.?
        | Jn?r\.?
        | Jn?r\.?,?\sEsq\.?
        | M\.?[BDS]\.?                       # MB, MD, MS
        | MPH
        | P\.?\s?A\.?
        | PC
        | Ph\.?\s?d\.?
        | SC
        | Sn?r\.?(?>,?\sEsq)?\.?             # Snr, Sr, Snr Esq, Sr Esq
        | V\.?M\.?D\.?
      )
    !xo

    # Internal: Regex last name prefixes - mostly which incorporate a space between it and the family name
    # Ends in the space which should be between it. It's a partial regex compared to use.
    LAST_NAME_PART = "(?i:" << %W!
      't
      Ab
      Ap
      Abu
      Al
      Bar
      Bath?
      Bet
      Bint?
      Da
      De\sCa
      De\sLa
      De\sLos
      de\sDe\sla
      De
      Degli
      De[lnrs]
      Dele
      Dell[ae]
      D[iu]
      Dos
      El
      Fitz
      Gil
      Het
      in
      in\shet
      Ibn
      Kil
      L[aeo]
      M[ai\']?c?
      Mhic
      Maol
      M[au]g
      Naka
      中
      Neder
      N[ií]'?[cgn]?
      Nord
      Norr
      Ny
      Ó
      Øst
      Öfver
      Öst
      Öster
      Över
      Öz
      Pour
      St\.?
      San
      Stor
      Söder
      Ter?
      Tre
      U[ií]?
      Vd
      Van\s't
      V[ao]n
      V[ao]n\sDe[nr]
      Ved\.?
      Vda\.?\sde\sDe\sla
      Vest
      Väst
      Väster
      Zu
      Y
    !.join('|') << ")\s"

    # Creates a name parsing object
    def initialize( opts={} )

      @opts = {
        :strip_mr   => true,
        :strip_mrs  => false,
        :case_mode  => 'proper',
        :couples    => false
      }.merge! opts
    end

    def parse(str)
      out = {}

      out[:orig]  = str.dup
      name = clean(str)

      # strip trailing suffices
      name.gsub!( /Mr\.? & Mrs\.?/i, "Mr. and Mrs." )

      # Flip last and first if contain comma
      name.gsub!( /;/, "" )
      name.gsub!(/(.+),(.+)/, "\\2 ;\\1")
      name.gsub!(/,/, "")
      name.strip!
      
      name.gsub!(/\sand\s/i, ' & ') if @opts[:couples]

      # trying to correct something like "Mr and Mrs Frank Bogart"
      if @opts[:couples] && name.match(/&/)

        names = name.split(/&/)
        name_one = names[0].strip! # presuming it doesn't have a full name
        name_two = names[1].strip! # presuming it does have a full name

        out[:title2] = get_title(name_two)
        out[:suffix2] = get_suffix(name_two)
        parts = get_name_parts(name_two)
        out[:parsed2] = parts[:parsed]
        out[:first2] = parts[:first]
        out[:middle2] = parts[:middle]
        out[:last] = parts[:last]

        # try first
        out[:title] = get_title(name_one)
        out[:suffix] = get_suffix(name_one)
        name_one = "#{name_one} #{out[:last]}"
        parts = get_name_parts(name_one, true)
        out[:parsed] = parts[:parsed]
        out[:first] = parts[:first]
        out[:middle] = parts[:middle]

        out[:multiple] = true if out[:parsed] && out[:parsed2]
      else
        out[:title] = get_title(name)
        out[:suffix] = get_suffix(name)
        parts = get_name_parts(name)
        out[:parsed] = parts[:parsed]
        out[:first] = parts[:first]
        out[:middle] = parts[:middle]
        out[:last] = parts[:last]
      end

      if @opts[:case_mode] == 'proper'
        [ :title, :first, :middle, :last, :suffix, :clean, :first2, :middle2, :title2, :suffix2 ].each do |part|
          next if part == :suffix
          out[part] = proper( out[part] ) unless out[part].nil?
        end
      elsif @opts[:case_mode] == 'upper'
        [ :title, :first, :middle, :last, :suffix, :clean, :first2, :middle2, :title2, :suffix2 ].each do |part|
          out[part].upcase! unless out[part].nil?
        end
      end

      out[:clean] = name
      return {
        :title => "",
        :first => "",
        :middle => "",
        :last => "",
        :suffix => "",
        :title2 => "",
        :first2 => "",
        :middle2 => "",
        :suffix2 => "",
        :clean => "",
        :parsed => false,
        :parsed2 => false,
        :multiple => false
      }.merge(out)

    end


    def clean(str)
      str.scrub!
      return '' if str.nil?
      # remove illegal characters
      str.gsub!(/[^\p{Alpha}\-\'\.&\/ \,]/, "" )
      str.gsub!(/\s+/, " ").strip!
      str
    end

    def get_title(str)
      title = ""
      if m = TITLES.match(str)
        title = m[1].strip
        str.sub!(title, "").strip!
      end
      return title
    end

    # get_suffix destroys the name parameter
    def get_suffix(str)
      suffixes = []
      suffixes = str.scan(SUFFIXES).flatten
      suffixes.each { |s| str.sub!(/\b#{s}/, "").strip! }
      suffixes.join " "
    end

    def get_name_parts( name, no_last_name = false )

      first  = ""
      middle = ""
      last   = ""

      parsed = true

      case name
      # M ERICSON
      when /^(\p{Alpha})\.? ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        last   = $2

      # M E ERICSON
      when /^(\p{Alpha})\.? (\p{Alpha})\.? ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = $2
        last   = $3

      # M.E. ERICSON
      when /^(\p{Alpha})\.(\p{Alpha})\. ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = $2
        last   = $3

      # M E E ERICSON
      when /^(\p{Alpha})\.? (\p{Alpha})\.? (\p{Alpha})\.? ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = "#{$2} #{$3}"
        last   = $4

      # M EDWARD ERICSON
      when /^(\p{Alpha})\.? ([\p{Alpha}\-\']+) ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = $2
        last   = $3

      # MATTHEW E ERICSON
      when /^([\p{Alpha}\-\']+) (\p{Alpha})\.? ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = $2
        last   = $3

      # MATTHEW E E ERICSON
      when /^([\p{Alpha}\-\']+) (\p{Alpha})\.? (\p{Alpha})\.? ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = "#{$2} #{$3}"
        last   = $4

      # MATTHEW E.E. ERICSON
      when /^([\p{Alpha}\-\']+) (\p{Alpha}\.\p{Alpha}\.) ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = $2
        last   = $3

      # MATTHEW ERICSON
      when /^([\p{Alpha}\-\']+) ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        last   = $2

      # MATTHEW EDWARD ERICSON
      when /^([\p{Alpha}\-\']+) ([\p{Alpha}\-\']+) ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = $2
        last   = $3

      # MATTHEW E. SHEIE ERICSON
      when /^([\p{Alpha}\-\']+) (\p{Alpha})\.? ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\'\ ]+)$/i
        first  = $1
        middle = $2
        last   = $3

      # M.E.N. ERICSON
      when /^((\p{Alpha}\.)+) ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        last   = $2

      when /^([\p{Alpha}\-\']+) ([\p{Alpha}\-\'\. ]+?) ((?>#{LAST_NAME_PART})?[\p{Alpha}\-\']+)$/i
        first  = $1
        middle = $2
        last   = $3

      else
        parsed = false
      end
      
      last.gsub!( /;/, "" )

      return { :parsed => parsed, :first => first, :middle => middle, :last => last }
    end



    def proper ( name )

      fixed = name.downcase

      # Now uppercase first letter of every word. By checking on word boundaries,
      # we will account for apostrophes (D'Angelo) and hyphenated names
      fixed.gsub!( /\b(\w+)/ ) { |m| m.match( /^[ixv]$+/i ) ? m.upcase :  m.capitalize }

      # Name case Macs and Mcs
      # Exclude names with 1-2 letters after prefix like Mack, Macky, Mace
      # Exclude names ending in a,c,i,o,z or j, typically Polish or Italian

      if fixed.match( /\bMac[\p{Lower}]{2,}[^a|c|i|o|z|j]\b/i  )

        fixed.gsub!( /\b(Mac)([\p{Lower}]+)/i ) do |m|
          $1 + $2.capitalize
        end

        # Now correct for "Mac" exceptions
        fixed.gsub!( /MacHin/i,  'Machin' )
        fixed.gsub!( /MacHlin/i, 'Machlin' )
        fixed.gsub!( /MacHar/i,  'Machar' )
        fixed.gsub!( /MacKle/i,  'Mackle' )
        fixed.gsub!( /MacKlin/i, 'Macklin' )
        fixed.gsub!( /MacKie/i,  'Mackie' )

        # Portuguese
        fixed.gsub!( /MacHado/i,  'Machado' )

        # Lithuanian
        fixed.gsub!( /MacEvicius/i, 'Macevicius' )
        fixed.gsub!( /MacIulis/i,   'Maciulis' )
        fixed.gsub!( /MacIas/i,     'Macias' )

      elsif fixed.match( /\bMc/i )
        fixed.gsub!( /\b(Mc)([\p{Lower}]+)/i ) do |m|
          $1 + $2.capitalize
        end

      end

      # Exceptions (only 'Mac' name ending in 'o' ?)
      fixed.gsub!( /Macmurdo/i, 'MacMurdo' )

      return fixed

    end

  end
end