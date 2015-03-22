module People
  # Class to parse names into their components like first, middle, last, etc.
  class NameParser

    TITLES = %r!
      ^(
        (?:Lt|Leut|Lieut)\.?
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
        |  Dhr\.?
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
        | Insp\.?
        | Judge
        | Justice
        | Lady
        | Lieutenant(?:\s(?:Commander|Colonel|General))?  # Lieutenant, Lieutenant Commander, Lieutenant Colonel, Lieutenant General
        | Lord
        | Lt\.?(?:\s(?:Cdr|Col|Gen)\.?)?                  # Lt, Lt Col, Lt Cdr, Lt Gen
        | M/s\.?
        | Madam(?:e)?
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
    !xo;
    
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
    !xo;

    attr_reader :seen, :parsed

    # Creates a name parsing object
    def initialize( opts={} )

      @name_chars = "\\p{Alnum}\\-\\'"
      @nc = @name_chars

      @opts = {
        :strip_mr   => true,
        :strip_mrs  => false,
        :case_mode  => 'proper',
        :couples    => false
      }.merge! opts

      ## constants

      @last_name_p = "((;.+)|(((Mc|Mac|Des|Dell[ae]|Del|De La|De Los|Da|Di|Du|La|Le|Lo|St\.|Den|Von|Van|Von Der|Van De[nr]) )?([#{@nc}-]+)))";
      @mult_name_p = "((;.+)|(((Mc|Mac|Des|Dell[ae]|Del|De La|De Los|Da|Di|Du|La|Le|Lo|St\.|Den|Von|Van|Von Der|Van De[nr]) )?([#{@nc} ]+)))";
      
      @seen = 0
      @parsed = 0;

    end

    def parse( name )

      @seen += 1

      clean  = ''
      out = Hash.new( "" )

      out[:orig]  = name.dup

      name = name.dup

      name = clean( name )

      # strip trailing suffices
      temp_suffix = []
      name.gsub!( /Mr\.? \& Mrs\.?/i, "Mr. and Mrs." )

      # Flip last and first if contain comma
      name.gsub!( /;/, "" )
      name.gsub!( /(.+),(.+)/, "\\2 ;\\1" )


      name.gsub!( /,/, "" )
#      name << " " + temp_suffix.join(' ')
      name.strip!

      if @opts[:couples]
        name.gsub!( / +and +/i, " \& " )
      end



      if @opts[:couples] && name.match( /\&/ )

        names = name.split( / *& */ )
        a = names[0]
        b = names[1]

        out[:title2] = get_title( b );
        out[:suffix2] = get_suffix( b );

        b.strip!

        parts = get_name_parts( b )

        out[:parsed2] = parts[0]
        out[:first2] = parts[1]
        out[:middle2] = parts[2]
        out[:last] = parts[3]

        out[:title] = get_title( a );
        out[:suffix] = get_suffix( a );

        a.strip!
        a += " "

        parts = get_name_parts( a, true )

        out[:parsed] = parts[0]
        out[:first] = parts[1]
        out[:middle] = parts[2]

        if out[:parsed] && out[:parsed2]
          out[:multiple] = true
        else
          out = Hash.new( "" )
        end


      else
        out[:suffix] = ''

        out[:title] = get_title( name );
        out[:suffix] = get_suffix( name );
        parts = get_name_parts( name )

        out[:parsed] = parts[0]
        out[:first] = parts[1]
        out[:middle] = parts[2]
        out[:last] = parts[3]

      end


      if @opts[:case_mode] == 'proper'
        [ :title, :first, :middle, :last, :suffix, :clean, :first2, :middle2, :title2, :suffix2 ].each do |part|
          next if part == :suffix && out[part].match( /^[iv]+$/i );
          out[part] = proper( out[part] )
        end

      elsif @opts[:case_mode] == 'upper'
        [ :title, :first, :middle, :last, :suffix, :clean, :first2, :middle2, :title2, :suffix2 ].each do |part|
          out[part].upcase!
        end

      else

      end

      if out[:parsed]
        @parsed += 1
      end

      out[:clean] = name

      return {
        :title       => "",
        :first       => "",
        :middle      => "",
        :last        => "",
        :suffix      => "",

        :title2      => "",
        :first2      => "",
        :middle2     => "",
        :suffix2     => "",

        :clean       => "",

        :parsed      => false,

        :parsed2     => false,

        :multiple    => false
      }.merge( out )

    end


    def clean( s )
      s.scrub!
      # remove illegal characters
      s.gsub!( /[^\p{Alnum}\-\'\.&\/ \,]/, "" )
      # remove repeating spaces
      s.gsub!( /  +/, " " )
      s.gsub!( /\s+/, " " )
      s.strip!
      s
    end

    def get_title( name )

      if m = TITLES.match(name)
        title = m[1].strip
        name.sub!(title, "").strip!
        return title
      end

      return ""
    end

    # get_suffix destroys the name parameter
    def get_suffix( name )
      suffixes = []
      suffixes = name.scan(SUFFIXES).flatten
      suffixes.each do |s|
        name.sub!(/\b#{s}/, "")
        name.strip!
      end
      suffixes.join " "
    end

    def get_name_parts( name, no_last_name = false )

      first  = ""
      middle = ""
      last   = ""

      if no_last_name
        last_name_p = ''
        mult_name_p = ''
      else
        last_name_p = @last_name_p
        mult_name_p = @mult_name_p
      end

      parsed = false

      u1c = "\\p{Alpha}"

      # M ERICSON
      if name.match( /^([#{u1c}])\.? (#{last_name_p})$/i )
        first  = $1;
        middle = '';
        last   = $2;
        parsed = true

        # M E ERICSON
      elsif name.match( /^([#{u1c}])\.? ([#{u1c}])\.? (#{last_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true

        # M.E. ERICSON
      elsif name.match( /^([#{u1c}])\.([#{u1c}])\. (#{last_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true

        # M E E ERICSON
      elsif name.match( /^([#{u1c}])\.? ([#{u1c}])\.? ([#{u1c}])\.? (#{last_name_p})$/i )
        first  = $1;
        middle = $2 + ' ' + $3;
        last   = $4;
        parsed = true

        # M EDWARD ERICSON
      elsif name.match( /^([#{u1c}])\.? ([#{@nc}]+) (#{last_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true

        # MATTHEW E ERICSON
      elsif name.match( /^([#{@nc}]+) ([#{u1c}])\.? (#{last_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true

        # MATTHEW E E ERICSON
      elsif name.match( /^([#{@nc}]+) ([#{u1c}])\.? ([#{u1c}])\.? (#{last_name_p})$/i )
        first  = $1;
        middle = $2 + ' ' + $3;
        last   = $4;
        parsed = true

        # MATTHEW E.E. ERICSON
      elsif name.match( /^([#{@nc}]+) ([#{u1c}]\.[#{u1c}]\.) (#{last_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true

        # MATTHEW ERICSON
      elsif name.match( /^([#{@nc}]+) (#{last_name_p})$/i )
        first  = $1;
        middle = '';
        last   = $2;
        parsed = true

        # MATTHEW EDWARD ERICSON
      elsif name.match( /^([#{@nc}]+) ([#{@nc}]+) (#{last_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true

        # MATTHEW E. SHEIE ERICSON
      elsif name.match( /^([#{@nc}]+) ([#{u1c}])\.? (#{mult_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true

        # M.E.N. ERICSON
      elsif name.match( /^(([#{u1c}]\.)+) (#{last_name_p})$/i )
        first  = $1;
        middle = ''
        last   = $3;
        parsed = true

      elsif name.match( /^([#{@nc}]+) ([#{@nc} .]+?) (#{last_name_p})$/i )
        first  = $1;
        middle = $2;
        last   = $3;
        parsed = true
      end

      last.gsub!( /;/, "" )

      return [ parsed, first, middle, last ];

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
        fixed.gsub!( /MacHado/i,  'Machado' );

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