package com.amazon.sample.maa.artstudio;

import java.util.LinkedList;
import java.util.List;

public final class Constants {

    public static final String OFFSET_KEY = "offsetKey";

    // Art Alternatives Marquis Desk Easel
    public static final String EASEL_ASIN = "B002Y6CWCM";

    // Art Advantage Oil and Acrylic Brush Set, 24-Piece
    public static final String BRUSH_ASIN = "B0027AANDA";

    // Furinno 11192B (99797B) Efficient Computer Desk, Black/Grey
    public static final String DESK_ASIN = "B006G2Z8IU";

    // Ticonderoga Yellow Pencil, No.1 Extra Soft Lead, Dozen DIX13881
    public static final String PENCIL_ASIN = "B001CXWQ6U";

    // MG38-BK 38" Acoustic Guitar Starter Package, Black
    public static final String GUITAR_ASIN = "B000KQ4MDK";

    // D'Addario EJ16-3D Phosphor Bronze Acoustic Guitar Strings, Light, 3 Sets
    public static final String STRING_ASIN = "B000OR2RNM";

    public static final List<String> ASIN_LIST = new LinkedList<String>();
    static {
        ASIN_LIST.add(EASEL_ASIN);
        ASIN_LIST.add(DESK_ASIN);
        ASIN_LIST.add(GUITAR_ASIN);
        ASIN_LIST.add(BRUSH_ASIN);
        ASIN_LIST.add(PENCIL_ASIN);
        ASIN_LIST.add(STRING_ASIN);
    }
}
