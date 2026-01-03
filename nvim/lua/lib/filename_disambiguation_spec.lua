local disambiguation = require('lib.filename_disambiguation')

-- The goal is to match the filename disambiguation of https://github.com/fholgado/minibufexpl.vim

describe('filename_disambiguation', function()
    it('single file shows basename only', function()
        assert.are.same(
            { [1] = 'file_a.py' },
            disambiguation.disambiguate_filenames({
                [1] = '/home/user/project/file_a.py',
            })
        )
    end)

    it('files with different names show basename only', function()
        assert.are.same(
            {
                [1] = 'file_a.py',
                [2] = 'file_b.py',
            },
            disambiguation.disambiguate_filenames({
                [1] = '/home/user/project/file_a.py',
                [2] = '/home/user/project/file_b.py',
            })
        )
    end)

    it('two files with same name in different directories', function()
        assert.are.same(
            {
                [1] = 'three/file_a.py',
                [2] = 'ten/file_a.py',
            },
            disambiguation.disambiguate_filenames({
                [1] = '/home/user/one/two/three/file_a.py',
                [2] = '/home/user/one/two/ten/file_a.py',
            })
        )
    end)

    it('uses first unique ancestor, with abbreviated middle levels', function()
        assert.are.same(
            {
                [1] = 'three/-/file_a.py',
                [2] = 'ten/-/file_a.py',
            },
            disambiguation.disambiguate_filenames({
                [1] = '/home/user/one/three/two/file_a.py',
                [2] = '/home/user/one/ten/two/file_a.py',
            })
        )
    end)

    it('spells out middle levels if needed', function()
        assert.are.same(
            {
                [1] = 'three/-/file_a.py',
                [2] = 'ten/two/file_a.py',
                [3] = 'ten/four/file_a.py',
            },
            disambiguation.disambiguate_filenames({
                [1] = '/home/user/one/three/two/file_a.py',
                [2] = '/home/user/one/ten/two/file_a.py',
                [3] = '/home/user/one/ten/four/file_a.py',
            })
        )
    end)

    it('mixed scenarios', function()
        assert.are.same(
            {
                [1] = 'three/-/file_a.py',
                [2] = 'ten/two/file_a.py',
                [3] = 'ten/four/file_a.py',
                [4] = 'file_b.py',
            },
            disambiguation.disambiguate_filenames({
                [1] = '/home/user/one/three/two/file_a.py',
                [2] = '/home/user/one/ten/two/file_a.py',
                [3] = '/home/user/one/ten/four/file_a.py',
                [4] = '/home/user/one/ten/four/file_b.py',
            })
        )
    end)

    it('same filename on different levels', function()
        assert.are.same(
            {
                [1] = 'one/file_a.py',
                [2] = 'file_a.py',
            },
            disambiguation.disambiguate_filenames({
                [1] = '/home/user/one/file_a.py',
                [2] = '/home/user/file_a.py',
            })
        )
    end)

    it('empty paths', function()
        assert.are.same({}, disambiguation.disambiguate_filenames({}))
    end)
end)
