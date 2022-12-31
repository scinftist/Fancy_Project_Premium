// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721FancyMintEnumRef.sol";

// import "@openzeppelin/contracts@4.7.0/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

import "@openzeppelin/contracts@4.7.0/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts@4.7.0/utils/Base64.sol";

contract superCol is ERC721FancyMintEnum, Ownable {
    using Strings for uint256;
    string[] private colors = [
        "D00000",
        "8A817C",
        "0029AB",
        "7A4419",
        "FFC300",
        "008000",
        "FF7900",
        "5A189A"
    ];
    string[] private colorsName = [
        "Guardsman Red",
        "Schooner",
        "Klein Blue",
        "Russet",
        "Amber",
        "Japanese Laurel",
        "Flush Orange",
        "Seance"
    ];
    // string internal colors =
    //     "34757130A9609306A1E205EE29C9CF9252500FF190066FFD7FF82FD482";

    string private head =
        '<svg width="398" height="632" viewBox="0 0 398 632" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="398" height="632" fill="#e9ecef"/>';
    string private c1 = '<circle cx="';
    string private c2 = '" cy="';
    string private c3 = '" r="';
    string private c4 = '" fill="#';
    string private c5 = '" fill-opacity="0.';
    string private c6 = '"/>';
    string private tail =
        '<rect x="5" y="5" width="388" height="622" stroke="#cbc5bf" stroke-width="10"/></svg>';

    struct circ {
        uint256 prime;
        uint256 cx;
        uint256 cy;
        uint256 opac;
    }
    mapping(uint256 => circ) private circMap;

    // mapping(uint256 => color) private colorMap;
    ///
    string private name_ = "Fancy Project : Premeium";
    string private symbol_ = "FPP";
    uint256 private maxSupply_ = 999;
    address private preOwner_ = 0xaBF060C60EB89100e519777CF806663a61c2aC4f;

    //
    bool private notFinialized = true;

    constructor() ERC721FancyMintEnum(name_, symbol_, maxSupply_, preOwner_) {
        circMap[0] = circ(17, 10, 10, 6);
        circMap[1] = circ(19, 388, 388, 55);
        circMap[2] = circ(29, 154, 622, 53);
        circMap[3] = circ(31, 10, 478, 50);
        circMap[4] = circ(41, 100, 388, 47);
        circMap[5] = circ(43, 154, 442, 45);
        circMap[6] = circ(59, 118, 478, 40);
        circMap[7] = circ(61, 100, 460, 35);
    }

    // in case the marketplace need this
    function emitHandlerSingle() public onlyOwner {
        require(notFinialized, "finalized!0");
        emit ConsecutiveTransfer(0, maxSupply_ - 1, address(0), preOwner_);
    }

    function finalizer() public onlyOwner {
        require(notFinialized, "finalized!1");
        notFinialized = false;
    }

    // function get_color(uint256 colorNum) internal view {
    //     return colors[colorNum * 6:(colorNum + 1) * 6];
    // }
    function make_base8(uint256 _tokenId) internal pure returns (uint256) {
        uint256 b8 = 0;
        for (uint256 i = 0; i < 8; i++) {
            b8 += ((_tokenId >> (i * 3)) & 7) * 10**i;
        }
        return b8;
    }

    function digit_count(uint256 _tokenId) internal pure returns (uint256) {
        uint256 _sum = 0;

        for (uint256 i = 0; i < 8; i++) {
            _sum += 10**((_tokenId >> (i * 3)) & 7);
        }
        return _sum;
    }

    function make_meta(uint256 _tokenId) private view returns (string memory) {
        string
            memory _out = '{"description": "a tale of no transaction fee minting.","attributes": [';
        uint256 t8 = make_base8(_tokenId);
        uint256 s8 = digit_count(_tokenId);
        uint256 _s;
        bool _f = false;
        for (uint256 i = 0; i < 8; i++) {
            if (_f == true) {
                _out = string(abi.encodePacked(_out, ","));
            } else {
                _f = true;
            }
            _out = string(
                abi.encodePacked(
                    _out,
                    '{"trait_type": "Circle #',
                    i.toString(),
                    '","value": "',
                    colorsName[(t8 / (10**i)) % 10],
                    '"}'
                )
            );
        }
        for (uint256 j = 0; j < 8; j++) {
            _s = (s8 / (10**j)) % 10;
            if (_s > 0) {
                _out = string(
                    abi.encodePacked(
                        _out,
                        ',{"trait_type": " ',
                        _s.toString(),
                        ' of a kind","value": "',
                        colorsName[j],
                        '"}'
                    )
                );
            }
        }
        _out = string(abi.encodePacked(_out, "] , "));

        return _out;
    }

    function first_half(uint256 _circleNum)
        internal
        view
        returns (string memory)
    {
        uint256 _cx = circMap[_circleNum].cx;
        uint256 _cy = circMap[_circleNum].cy;
        return
            string(
                abi.encodePacked(c1, _cx.toString(), c2, _cy.toString(), c3)
            );
    }

    function get_color(uint256 _circleNum, uint256 _tokenId)
        internal
        view
        returns (string memory)
    {
        uint256 _colorNum = (_tokenId >> (_circleNum * 3)) & 7;
        // uint256 _colorNum = (_tokenId / (10**_circleNum)) % 10;
        return colors[_colorNum];
    }

    function get_radius(uint256 _circleNum, uint256 _tokenId)
        internal
        view
        returns (string memory)
    {
        uint256 _prime = circMap[_circleNum].prime;
        uint256 _temp = ((((_tokenId % _prime) + 1) * 420) / _prime);
        return (_temp + 5).toString();
    }

    function make_circle(uint256 circleNum, uint256 tokenId)
        internal
        view
        returns (string memory)
    {
        string memory _radius = get_radius(circleNum, tokenId);
        string memory _color = get_color(circleNum, tokenId);
        // string memory _color = get_color(_colorNum);
        // string memory
        string memory ct;
        if (circleNum == 7) {
            ct = '" stroke="#260701" stroke-width="2.5"/>';
        } else {
            ct = c6;
        }
        return
            string(
                abi.encodePacked(
                    first_half(circleNum),
                    _radius,
                    c4,
                    _color,
                    c5,
                    circMap[circleNum].opac.toString(),
                    ct
                )
            );
    }

    function generateSVG(uint256 id) internal view returns (string memory) {
        string memory _svgString = head;
        for (uint256 i = 0; i < 8; i++) {
            _svgString = string(
                abi.encodePacked(_svgString, make_circle(i, id))
            );
        }
        return string(abi.encodePacked(_svgString, tail));
    }

    function constructTokenURI(uint256 id)
        internal
        view
        returns (string memory)
    {
        uint256 virtualID = id * 16001;
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                make_meta(virtualID),
                                '"image": "data:image/svg+xml;base64,',
                                Base64.encode(bytes(generateSVG(virtualID))),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function tokenURI(uint256 id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(id), "token does not exist!");
        return constructTokenURI(id);
    }
}
